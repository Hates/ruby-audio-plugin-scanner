require 'pathname'

class AudioPluginScanner
  def initialize
    @plugin_locations = {
      'AU_Components_System' => '/Library/Audio/Plug-Ins/Components',
      'AU_Components_User' => '~/Library/Audio/Plug-Ins/Components',
      'VST_System' => '/Library/Audio/Plug-Ins/VST',
      'VST_User' => '~/Library/Audio/Plug-Ins/VST',
      'VST3_System' => '/Library/Audio/Plug-Ins/VST3',
      'VST3_User' => '~/Library/Audio/Plug-Ins/VST3',
      'AAX_System' => '/Library/Application Support/Avid/Audio/Plug-Ins'
    }
  end

  def expand_path(path)
    Pathname.new(path).expand_path
  end

  def scan_directory(directory, plugin_type)
    plugins = []
    return plugins unless directory.exist?

    begin
      directory.children.select(&:directory?).each do |item|
        plugin_info = {
          name: item.basename.to_s.gsub(/\.(component|vst|vst3|aaxplugin)$/, ''),
          type: plugin_type,
          path: item.to_s,
          location: item.to_s.include?('/Users/') ? 'User' : 'System'
        }
        plugins << plugin_info
      end
    rescue Errno::EACCES
      # Permission denied, skip this directory
    end

    plugins
  end

  def scan_all_plugins
    all_plugins = {
      'AU_Components' => [],
      'VST' => [],
      'VST3' => [],
      'AAX' => []
    }

    @plugin_locations.each do |location_key, path_str|
      directory = expand_path(path_str)

      case location_key
      when /Components/
        plugins = scan_directory(directory, 'AU Component')
        all_plugins['AU_Components'].concat(plugins)
      when /VST3/
        plugins = scan_directory(directory, 'VST3')
        all_plugins['VST3'].concat(plugins)
      when /VST(?!3)/
        plugins = scan_directory(directory, 'VST')
        all_plugins['VST'].concat(plugins)
      when /AAX/
        plugins = scan_directory(directory, 'AAX')
        all_plugins['AAX'].concat(plugins)
      end
    end

    all_plugins
  end

  def consolidate_plugins(plugins, include_paths = false)
    consolidated = {}
    
    plugins.each do |plugin_type, plugin_list|
      plugin_list.each do |plugin|
        name = plugin[:name]
        location = plugin[:location]
        
        # Create a unique key based on name and location for grouping
        key = "#{name}|#{location}"
        
        if consolidated[key]
          consolidated[key][:formats] << format_short_name(plugin_type)
          if include_paths
            consolidated[key][:paths] << {
              format: format_short_name(plugin_type),
              path: plugin[:path],
              type: plugin[:type]
            }
          end
        else
          consolidated[key] = {
            name: name,
            location: location,
            formats: [format_short_name(plugin_type)]
          }
          if include_paths
            consolidated[key][:paths] = [{
              format: format_short_name(plugin_type),
              path: plugin[:path],
              type: plugin[:type]
            }]
          end
        end
      end
    end
    
    consolidated.values
  end
  
  def format_short_name(plugin_type)
    case plugin_type
    when 'AU_Components'
      'AU'
    when 'VST'
      'VST'
    when 'VST3'
      'VST3'
    when 'AAX'
      'AAX'
    else
      plugin_type
    end
  end

  def print_summary(plugins)
    total_instances = plugins.values.sum(&:length)
    consolidated = consolidate_plugins(plugins)
    unique_plugins = consolidated.length

    puts "\n🎵 Audio Plugin Scanner for macOS"
    puts "=" * 50
    puts "Total plugin instances: #{total_instances}"
    puts "Unique plugins: #{unique_plugins}"
    puts

    puts "Consolidated Plugin List:"
    puts "-" * 40

    consolidated.sort_by { |p| p[:name].downcase }.each do |plugin|
      location_icon = plugin[:location] == 'User' ? '🏠' : '🏢'
      formats = plugin[:formats].uniq.sort.join(', ')
      puts "  #{location_icon} #{plugin[:name]} [#{formats}]"
    end
    puts
    
    # Show breakdown by format
    puts "Format Breakdown:"
    puts "-" * 20
    plugins.each do |plugin_type, plugin_list|
      next if plugin_list.empty?
      display_name = plugin_type == 'AU_Components' ? 'AU Components' : plugin_type
      puts "  #{display_name}: #{plugin_list.length}"
    end
  end

  def print_detailed(plugins)
    total_instances = plugins.values.sum(&:length)
    consolidated = consolidate_plugins(plugins, true)
    unique_plugins = consolidated.length

    puts "\n🎵 Audio Plugin Scanner for macOS (Detailed)"
    puts "=" * 70
    puts "Total plugin instances: #{total_instances}"
    puts "Unique plugins: #{unique_plugins}"
    puts

    puts "Consolidated Plugin List with Paths:"
    puts "-" * 70

    consolidated.sort_by { |p| p[:name].downcase }.each do |plugin|
      location_icon = plugin[:location] == 'User' ? '🏠' : '🏢'
      formats = plugin[:formats].uniq.sort.join(', ')
      puts "  #{location_icon} #{plugin[:name]} [#{formats}]"
      
      # Group paths by format and sort them
      paths_by_format = plugin[:paths].group_by { |p| p[:format] }
      paths_by_format.keys.sort.each do |format|
        paths_by_format[format].each do |path_info|
          puts "     #{format}: #{path_info[:path]}"
        end
      end
      puts
    end
    
    # Show breakdown by format
    puts "Format Breakdown:"
    puts "-" * 20
    plugins.each do |plugin_type, plugin_list|
      next if plugin_list.empty?
      display_name = plugin_type == 'AU_Components' ? 'AU Components' : plugin_type
      puts "  #{display_name}: #{plugin_list.length}"
    end
  end

  def print_by_type(plugins, plugin_type)
    # Map user input to internal keys
    plugin_type_key = case plugin_type.downcase
    when 'au'
      'AU_Components'
    when 'vst'
      'VST'
    when 'vst3'
      'VST3'
    when 'aax'
      'AAX'
    else
      plugin_type.upcase.gsub('-', '_')
    end

    if plugins[plugin_type_key] && !plugins[plugin_type_key].empty?
      plugin_list = plugins[plugin_type_key]
      display_name = plugin_type_key == 'AU_Components' ? 'AU Component' : plugin_type_key
      puts "\n#{display_name} Plugins (#{plugin_list.length} found):"
      puts "-" * 50

      plugin_list.sort_by { |p| p[:name].downcase }.each do |plugin|
        location_icon = plugin[:location] == 'User' ? '🏠' : '🏢'
        puts "  #{location_icon} #{plugin[:name]}"
      end
    else
      puts "\nNo #{plugin_type} plugins found."
    end
  end
end
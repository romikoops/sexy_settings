require 'singleton'
require 'yaml'

module SexySettings
  class Base
    include Singleton
    attr_reader :default, :custom, :command_line, :all_properties

    # Priorities: command_line > custom.yml > default.yml > nil
    def initialize
      config = self.configuration
      @default = load_settings(config.path_to_default_settings)
      @default = @default.merge({config.project_directory_option => config.path_to_project})
      @custom = load_settings(config.path_to_custom_settings)
      @all_properties = @default.merge(@custom)
      @command_line = {}
      unless ENV[config.env_variable_with_options].nil?
        ENV[config.env_variable_with_options].split(",").each{|opt_line| parse_setting(opt_line) if opt_line }
      end
      @all_properties.merge!(@command_line)
      @all_properties.each_pair{|k, v| @all_properties[k] = get_compound_value(v)}
    end

    def pretty_formatted_properties
      props_list = @all_properties.to_a
      max_key_size = props_list.map{|el| el.first.to_s.size}.max
      res = []
      res << ("###############################################################")
      res << ("#                          Settings                           #")
      res << ("###############################################################")
      res << ""
      res += props_list.map{|el| "#{indent}#{el[0]}#{indent + indent(max_key_size - el[0].to_s.size)}=#{indent}#{el[1]}"}.sort
      res << ""
      res.join("\n")
    end

  private

    def load_settings(path)
      File.exists?(path) ? YAML::load_file(path) : {}
    end

    def indent(space_count=nil)
      " "*(space_count.nil? ? 2 : space_count)
    end

    #  Parse the compound setting.
    #  Parts of this config_parser must be defined earlier.
    #  You can define an option as option=${another_option_name}/something
    def get_compound_value(value)
      if /\$\{(.*?)\}/.match(value.to_s)
        var = /\$\{(.*?)\}/.match(value.to_s)[1]
        exist_var = @all_properties[var]
        raise ArgumentError, "Did you define this setting '#{var}' before?" if exist_var.nil?
        value["${#{var}}"] = exist_var.to_s if var
        get_compound_value(value)
      end
      value
    end

    def method_missing(name, *args)
      if name.to_s =~ /=$/
        @all_properties[name.to_s] = args[0] if @all_properties.has_key?(name.to_s)
      else
        @all_properties[name.to_s]
      end
    end

    # Try to convert a value from String to other types (int, boolean, float)
    # Return the value as String if all tries have failed.
    # If the value is not of String type, return it as is.
    def try_convert_value(value)
      if value.class == String
        if /^[0-9]+$/.match(value) #int
          value.to_i
        elsif /^[0-9]+(\.)[0-9]*$/.match(value) #float
          value.to_f
        elsif (value.downcase == 'true') #boolean
          true
        elsif (value.downcase == 'true') #boolean
          false
        else
          value # can't parse, return String
        end
      else # value is not String, return it as is
        value
      end
    end

    #  Try to parse the setting's line
    #  Delimiter is "=", ignores double quotes in the start and end positions
    def parse_setting(line)
      raise ArgumentError, "Invalid pair: #{line}. Expected: name=value" unless line["="]
      param, value = line.split(/\s*=\s*/, 2)
      var_name = param.chomp.strip
      value = value.chomp.strip if value
      new_value = ''
      if (value)
        new_value = (value =~ /^["](.*)["]$/) ?  $1 : value
      end
      new_value = try_convert_value(new_value)
      @command_line[var_name] = new_value
    end
  end
end
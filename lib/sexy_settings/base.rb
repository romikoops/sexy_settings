require 'singleton'
require 'yaml'

module SexySettings
  class Base
    include Singleton
    attr_reader :default, :custom, :command_line, :all

    # Priorities: command_line > custom.yml > default.yml > nil
    def initialize
      config = SexySettings.configuration
      @default = load_settings(config.path_to_default_settings)
      @custom = load_settings(config.path_to_custom_settings)
      @all = @default.merge(@custom)
      @command_line = {}
      unless ENV[config.env_variable_with_options].nil?
        ENV[config.env_variable_with_options].split(config.cmd_line_option_delimiter).each{|opt_line| parse_setting(opt_line) if opt_line }
      end
      @all.merge!(@command_line)
      @all.each_pair{|k, v| @all[k] = get_compound_value(v)}
    end

    def as_formatted_text(which=:all)
      props_list = case which
                     when :all then @all
                     when :custom then @custom
                     when :default then @default
                     else ''
                    end.to_a
      max_key_size = props_list.map{|el| el.first.to_s.size}.max
      res = []
      title = "##{' '*20}#{which.to_s.capitalize} Settings#{' '*21}#"
      sharp_line = '#'*title.size
      res << sharp_line
      res << title
      res << sharp_line
      res << ''
      res += props_list.map{|el| "#{indent}#{el[0]}#{indent + indent(max_key_size - el[0].to_s.size)}=#{indent}#{el[1]}"}.sort
      res << ''
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
        exist_var = @all[var]
        raise ArgumentError, "Did you define this setting '#{var}' before?" if exist_var.nil?
        value["${#{var}}"] = exist_var.to_s if var
        get_compound_value(value)
      end
      value
    end

    def method_missing(name, *args)
      if name.to_s =~ /=$/
        @all[name.to_s] = args[0] if @all.has_key?(name.to_s)
      else
        @all[name.to_s]
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
        elsif (value.downcase == 'false') #boolean
          false
        elsif /^:(.+)$/.match(value)
          $1.to_sym
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
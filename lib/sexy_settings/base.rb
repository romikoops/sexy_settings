require 'singleton'
require 'yaml'
require_relative 'printable'
require_relative 'exceptions'

module SexySettings
  # This class represents core functionality
  class Base
    attr_reader :default, :custom, :command_line, :all

    include Singleton
    include Printable

    # Priorities: command_line > custom.yml > default.yml
    def initialize
      @default = load_default_settings
      @custom = load_custom_settings
      init_command_line_settings
      init_all_settings
      validate_default_settings
      define_dynamic_methods
    end

    def inspect
      'SexySettings::Base'
    end

    private

    def config
      SexySettings.configuration
    end

    def define_dynamic_methods
      @default.keys.each do |setting|
        self.class.instance_eval do
          define_method(setting) { @all[setting] }
          define_method("#{setting}=") do |value|
            @all[setting] = value
          end
        end
      end
    end

    def validate_default_settings
      incorrect_settings = @all.keys - @default.keys
      return if incorrect_settings.empty?
      path = config.path_to_default_settings
      raise SexySettings::MissingDefaultError, "Please specify defaults in '#{path}' config file:\n" +
                                               incorrect_settings.map { |el| "\t\t#{el}: someValue" }.join("\n")
    end

    def load_default_settings
      path = config.path_to_default_settings
      YAML.load_file(path) || {}
    end

    def load_custom_settings
      path = config.path_to_custom_settings
      return {} unless File.exist?(path)
      YAML.load_file(path) || {}
    end

    #  Parse the compound setting.
    #  Parts of this config_parser must be defined earlier.
    #  You can define an option as option=${another_option_name}/something
    def get_compound_value(value)
      return value unless /\$\{(.*?)\}/.match?(value.to_s)
      var = /\$\{(.*?)\}/.match(value.to_s)[1]
      exist_var = @all[var]
      raise ArgumentError, "Did you define this setting '#{var}' before?" if exist_var.nil?
      value["${#{var}}"] = exist_var.to_s if var
      get_compound_value(value)
    end

    # Try to convert a value from String to other types (int, boolean, float)
    # Return the value as String if all tries have failed.
    # If the value is not of String type, return it as is.
    def try_convert_value(value)
      return value.to_i if integer?(value)
      return value.to_f if float?(value)
      return true if boolean_true?(value)
      return false if boolean_false?(value)
      return convert_to_sym(value) if symbol?(value)
      value # can't parse, return String
    end

    def integer?(value)
      /^[0-9]+$/ =~ value
    end

    def float?(value)
      /^[0-9]+(\.)[0-9]*$/ =~ value # float
    end

    def boolean_true?(value)
      value.casecmp('true').zero?
    end

    def boolean_false?(value)
      value.casecmp('false').zero? # boolean
    end

    def symbol?(value)
      /^:(.+)$/ =~ value
    end

    def convert_to_sym(value)
      /^:(.+)$/ =~ value && Regexp.last_match(1).to_sym
    end

    #  Try to parse the setting's line
    #  Delimiter is "=", ignores double quotes in the start and end positions
    def parse_setting(line)
      raise ArgumentError, "Invalid pair: #{line}. Expected: name=value" unless line['=']
      param, value = line.split(/\s*=\s*/, 2)
      value = value.chomp.strip if value
      new_value = ''
      if value
        new_value = value =~ /^["](.*)["]$/ ? Regexp.last_match(1) : value
      end
      new_value = try_convert_value(new_value) if new_value.class == String
      [param.chomp.strip, new_value]
    end

    def init_command_line_settings
      @command_line = {}
      data = ENV[config.env_variable_with_options]
      return if data.nil?
      delimiter = config.cmd_line_option_delimiter
      data = data.split(delimiter).map { |el| parse_setting(el) if el }.compact
      @command_line = Hash[data]
    end

    def init_all_settings
      @all = @default.merge(@custom)
      @all.merge!(@command_line)
      @all.each_pair { |k, v| @all[k] = get_compound_value(v) }
    end
  end
end

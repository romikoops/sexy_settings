# frozen_string_literal: true
module SexySettings
  # This class holds all configuration settings
  class Configuration
    DEFAULT_OPTIONS = {
      path_to_default_settings: 'default.yml',
      path_to_custom_settings: 'custom.yml',
      path_to_project: '.',
      env_variable_with_options: 'SEXY_SETTINGS',
      cmd_line_option_delimiter: ','
    }.freeze

    DEFAULT_OPTIONS.keys.each { |option| attr_writer option }

    def cmd_line_option_delimiter
      ENV['SEXY_SETTINGS_DELIMITER'] ||
        @cmd_line_option_delimiter ||
        DEFAULT_OPTIONS[:cmd_line_option_delimiter]
    end

    def path_to_default_settings
      @path_to_default_settings || DEFAULT_OPTIONS[:path_to_default_settings]
    end

    def path_to_custom_settings
      @path_to_custom_settings || DEFAULT_OPTIONS[:path_to_custom_settings]
    end

    def path_to_project
      @path_to_project || DEFAULT_OPTIONS[:path_to_project]
    end

    def env_variable_with_options
      @env_variable_with_options || DEFAULT_OPTIONS[:env_variable_with_options]
    end
  end
end

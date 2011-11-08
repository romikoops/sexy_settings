module SexySettings
  class Configuration
    DEFAULT_OPTIONS = {
        :path_to_default_settings => "default.yml",
        :path_to_custom_settings => "custom.yml",
        :path_to_project => '.',
        :env_variable_with_options => 'OPTS',
        :cmd_line_option_delimiter => ','
    }
    DEFAULT_OPTIONS.keys.each{|option| attr_writer option}

    def initialize
      DEFAULT_OPTIONS.keys.each do |method|
        self.class.send(:define_method, method) do
          self.instance_variable_get("@#{method}") || DEFAULT_OPTIONS[method]
        end
      end
    end

  end
end
module SexySettings
  class Configuration
    DEFAULT_OPTIONS = {
        :path_to_default_settings => "default.yml",
        :path_to_custom_settings => "custom.yml",
        :path_to_project => '.',
        :env_variable_with_options => 'OPTS',
        :project_directory_option => 'project_dir'
    }
    DEFAULT_OPTIONS.keys.each{|option| attr_writer option}

    #TODO should be reimplemented without method_missing
    def method_missing(name, *args)
      if DEFAULT_OPTIONS.has_key?(name)
        self.instance_variable_get("@#{name}") || DEFAULT_OPTIONS[name]
      else
        raise "Method '#{name}' is missing"
      end
    end
  end
end
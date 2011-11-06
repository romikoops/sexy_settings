require 'spec_helper'

describe 'Base' do
  before :all do
    SexySettings.configure do |config|
      config.path_to_default_settings = File.expand_path("config.yaml", File.join(File.dirname(__FILE__), '..', '_config'))
      config.path_to_custom_settings = File.expand_path("overwritten.yaml", File.join(File.dirname(__FILE__), '..', '_config'))
      config.path_to_project = File.dirname(__FILE__)
      config.env_variable_with_options = 'OPTIONS'
      config.project_directory_option = 'project_directory'
    end
    if ENV.has_key?(SexySettings.configuration.env_variable_with_options)
      @original_options = ENV[SexySettings.configuration.env_variable_with_options]
    else
      @original_options = nil
    end
    ENV[SexySettings.configuration.env_variable_with_options] = "console_property=console CONSOLE value"
    @settings ||= settings
  end

  after :all do
    @original_options = ENV[SexySettings.configuration.env_variable_with_options]
    unless @original_options
      ENV[SexySettings.configuration.env_variable_with_options] = @original_options
    end
  end

  it "should be singleton object" do
    SexySettings::Base.respond_to?(:instance).should be_true
    SexySettings::Base.instance.is_a?(SexySettings::Base).should be_true
  end

  it "should have getter for default setting" do
    @settings.respond_to?(:default).should be_true
    expected_default_settings = {
        "default_property" => "default DEFAULT value",
        "overwritten_property" => "default OVERWRITTEN value",
        "console_property" => "default CONSOLE value",
        "project_directory" => SexySettings.configuration.path_to_project
    }
    @settings.default.should == expected_default_settings
  end

  it "should have getter for custom setting" do
    @settings.respond_to?(:default).should be_true
    expected_custom_settings = {
        "overwritten_property" => "overwritten OVERWRITTEN value",
        "console_property" => "overwritten CONSOLE value"
    }
    @settings.custom.should == expected_custom_settings
  end

  it "should have getter for all setting" do
    @settings.respond_to?(:default).should be_true
    expected_all_settings = {
        "default_property" => "default DEFAULT value",
        "overwritten_property" => "overwritten OVERWRITTEN value",
        "console_property" => "console CONSOLE value",
        "project_directory" => SexySettings.configuration.path_to_project}
    @settings.all.should == expected_all_settings
  end

  it "should print all settings in pretty formatted manner" do
    pending("implement test for me")
    #@settings.print_all #TODO implement test for me
  end

  it "should return project dir correctly" do
    @settings.project_directory.should == File.dirname(__FILE__) #TODO it is bug, and should be fixed
  end

  context "command line" do
    before :all do
      SexySettings.configure.env_variable_with_options = 'OPTS'
      ENV['OPTS'] = "string=Test, int=1, float=1.09, boolean_true=true, boolean_false=false, symbol=:foo"
    end

    after :all do
      SexySettings.configure.env_variable_with_options = 'OPTIONS'
    end

    it "should convert command line values to correct types" do
      pending("fix test")
      #TODO fix test
      #settings.send(:initialize)
      #settings.string.should == 'Test'
      #settings.int.should == 1
      #settings.float.should == 1.09
      #settings.boolean_true.should be_true
      #settings.boolean_false.should be_false
      #settings.symbol.should == :foo
    end
  end
end

def settings
  SexySettings::Base.instance()
end
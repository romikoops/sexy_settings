require 'spec_helper'

describe 'Base' do
  before :all do
    SexySettings.configure do |config|
      config.path_to_default_settings = File.expand_path("config.yaml", File.join(File.dirname(__FILE__), '..', '_config'))
      config.path_to_custom_settings = File.expand_path("overwritten.yaml", File.join(File.dirname(__FILE__), '..', '_config'))
      config.path_to_project = File.dirname(__FILE__)
      config.env_variable_with_options = 'OPTIONS'
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
        "console_property" => "default CONSOLE value"
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
        "console_property" => "console CONSOLE value"
    }
    @settings.all.should == expected_all_settings
  end

  it "should return specified pretty formatted settings for output" do
    expected = <<-eos
#######################################################
#                    All Settings                     #
#######################################################

  console_property      =  console CONSOLE value
  default_property      =  default DEFAULT value
  overwritten_property  =  overwritten OVERWRITTEN value
eos
    @settings.as_formatted_text.should == expected
  end

  context "command line" do
    before :all do
      SexySettings.configure.env_variable_with_options = 'OPTS'
      ENV['OPTS'] = "string=Test, int=1, float=1.09, boolean_true=true, boolean_false=false, symbol=:foo, reference = ${string}"
      @clone_settings = settings.class.clone.instance
    end

    after :all do
      SexySettings.configure.env_variable_with_options = 'OPTIONS'
    end

    it "should convert command line string value to String type" do
      @clone_settings.string.should == 'Test'
    end

    it "should convert command line integer value to Fixnum type" do
      @clone_settings.int.should == 1
      @clone_settings.int.class.should == Fixnum
    end

    it "should convert command line float value to Float type" do
      @clone_settings.float.should == 1.09
      @clone_settings.float.class.should == Float
    end

    it "should convert command line true value to TrueClass type" do
      @clone_settings.boolean_true.should be_true
    end

    it "should convert command line false value to FalseClass type" do
      @clone_settings.boolean_false.should be_false
      @clone_settings.boolean_false.class.should == FalseClass
    end

    it "should convert command line symbol value to Symbol type" do
      @clone_settings.symbol.should == :foo
    end

    it "should replace command line reference to correct value" do
      @clone_settings.reference == 'Test'
    end
  end
end

def settings
  SexySettings::Base.instance()
end
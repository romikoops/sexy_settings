require 'spec_helper'

describe 'Configuration' do
  before :all do
    @expected_opts = {
        :path_to_default_settings => "default.yml",
        :path_to_custom_settings => "custom.yml",
        :path_to_project => '.',
        :env_variable_with_options => 'OPTS',
        :cmd_line_option_delimiter => ','
    }
    @config = SexySettings::Configuration.new
  end

  it "should have correct default options" do
    SexySettings::Configuration.constants.should include(:DEFAULT_OPTIONS)
    SexySettings::Configuration::DEFAULT_OPTIONS.should == @expected_opts
  end

  it "should have setters for all options" do
    @expected_opts.keys.each{|key| @config.respond_to?("#{key}=").should be_true}
  end

  it "should return last value of specified option" do
    new_value = 'fake'
    @expected_opts.keys.each{|key| @config.send("#{key}=", new_value)}
    @expected_opts.keys.each{|key| @config.send(key).should == new_value}
  end

  it "should return default value of specified option" do
    config = SexySettings::Configuration.new
    @expected_opts.keys.each{|key| config.send(key).should == @expected_opts[key]}
  end
end
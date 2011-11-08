require 'spec_helper'

describe 'Core' do
  it "should have ability to reset settings" do
    new_delim = '#@#'
    old_delim = nil
    SexySettings.configure do |config|
      old_delim = config.cmd_line_option_delimiter
      config.cmd_line_option_delimiter = new_delim
    end
    SexySettings.configuration.cmd_line_option_delimiter.should ==(new_delim)
    SexySettings.reset
    SexySettings.configuration.cmd_line_option_delimiter.should ==(old_delim)
  end

  it "should return the same configuration object each time" do
    config = SexySettings.configuration
    config.is_a?(SexySettings::Configuration).should be_true
    config.object_id.should == SexySettings.configuration.object_id
  end

  it "should have ability to configure Configuration object with block" do
    SexySettings.configure do |config|
      config.is_a?(SexySettings::Configuration).should be_true
    end
  end

  it "should have ability to configure Configuration object without block" do
    SexySettings.configure.is_a?(SexySettings::Configuration).should be_true
  end
end
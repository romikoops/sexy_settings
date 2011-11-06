require 'spec_helper'

describe 'Core' do
  it "should have ability to reset settings" do
    new_path = 'path/to/file'
    old_path = nil
    SexySettings.configure do |config|
      old_path = config.path_to_project
      config.path_to_project = 'path/to/file'
    end
    SexySettings.configuration.path_to_project.should ==(new_path)
    SexySettings.reset
    SexySettings.configuration.path_to_project.should ==(old_path)
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
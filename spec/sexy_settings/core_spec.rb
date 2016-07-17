# frozen_string_literal: true
require 'spec_helper'

describe 'Core' do
  it 'should have ability to reset settings' do
    new_delim = '#@#'
    old_delim = nil
    SexySettings.configure do |config|
      old_delim = config.cmd_line_option_delimiter
      config.cmd_line_option_delimiter = new_delim
    end
    expect(SexySettings.configuration.cmd_line_option_delimiter).to eq(new_delim)
    SexySettings.reset
    expect(SexySettings.configuration.cmd_line_option_delimiter).to eq(old_delim)
  end

  it 'should return the same configuration object each time' do
    config = SexySettings.configuration
    expect(config).to be_a(SexySettings::Configuration)
    expect(config.object_id).to eq(SexySettings.configuration.object_id)
  end

  it 'should have ability to configure Configuration object with block' do
    SexySettings.configure do |config|
      expect(config).to be_a(SexySettings::Configuration)
    end
  end

  it 'should have ability to configure Configuration object without block' do
    expect(SexySettings.configure).to be_a(SexySettings::Configuration)
  end
end

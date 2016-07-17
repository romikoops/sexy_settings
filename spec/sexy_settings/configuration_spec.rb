# frozen_string_literal: true
require 'spec_helper'

describe 'Configuration' do
  let(:expected_opts) do
    {
      path_to_default_settings: 'default.yml',
      path_to_custom_settings: 'custom.yml',
      path_to_project: '.',
      env_variable_with_options: 'SEXY_SETTINGS',
      cmd_line_option_delimiter: ','
    }
  end
  let(:config) { SexySettings::Configuration.new }

  it 'should have correct default options' do
    expect(SexySettings::Configuration.constants).to include(:DEFAULT_OPTIONS)
    expect(SexySettings::Configuration::DEFAULT_OPTIONS).to eq(expected_opts)
  end

  it 'should have setters for all options' do
    expected_opts.keys.each { |key| expect(config).to be_respond_to("#{key}=") }
  end

  it 'should return last value of specified option' do
    new_value = 'fake'
    expected_opts.keys.each do |key|
      config.send("#{key}=", new_value)
      expect(config.send(key)).to eq(new_value)
    end
  end

  it 'should return default value of specified option' do
    expected_opts.keys.each { |key| expect(config.send(key)).to eq(expected_opts[key]) }
  end

  context 'when SEXY_SETTINGS_DELIMITER env variable specified' do
    before { ENV['SEXY_SETTINGS_DELIMITER'] = '$' }
    after { ENV['SEXY_SETTINGS_DELIMITER'] = nil }

    it 'should override specified delimiter' do
      config.cmd_line_option_delimiter = ';'
      expect(config.cmd_line_option_delimiter).to eq('$')
    end
  end
end

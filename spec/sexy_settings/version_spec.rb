# frozen_string_literal: true
require 'spec_helper'

describe 'Version' do
  it 'should contains VERSION constant with correct format' do
    expect(SexySettings.constants).to include(:VERSION)
    expect(SexySettings::VERSION).to match(/^\d+\.\d+\.\d+$/)
  end
end

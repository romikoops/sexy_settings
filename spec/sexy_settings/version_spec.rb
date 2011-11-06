require 'spec_helper'

describe 'Version' do
  it "should contains VERSION constant with correct format" do
    SexySettings.constants.should include(:VERSION)
    SexySettings::VERSION.should match(/^\d+\.\d+\.\d+$/)
  end
end
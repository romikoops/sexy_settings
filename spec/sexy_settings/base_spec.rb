require 'spec_helper'

RSpec.describe 'Base' do
  context 'when default and custom settings exists and not blank' do
    before :all do
      SexySettings.configure do |config|
        config.path_to_default_settings =
          File.expand_path('config.yaml', File.join(File.dirname(__FILE__), '..', '_config'))
        config.path_to_custom_settings =
          File.expand_path('overwritten.yaml', File.join(File.dirname(__FILE__), '..', '_config'))
        config.path_to_project = File.dirname(__FILE__)
        config.env_variable_with_options = 'OPTIONS'
      end
      @original_options = if ENV.key?(SexySettings.configuration.env_variable_with_options)
                            ENV[SexySettings.configuration.env_variable_with_options]
                          else
                            nil
                          end
      ENV[SexySettings.configuration.env_variable_with_options] = 'console_property=console CONSOLE value'
      @settings ||= settings
    end

    after :all do
      @original_options = ENV[SexySettings.configuration.env_variable_with_options]
      unless @original_options
        ENV[SexySettings.configuration.env_variable_with_options] = @original_options
      end
    end

    it 'should be singleton object' do
      expect(SexySettings::Base.respond_to?(:instance)).to be_truthy
      expect(SexySettings::Base.instance).to be_a(SexySettings::Base)
    end

    it 'should have getter for default setting' do
      expect(@settings).to be_respond_to(:default)
      expected_default_settings = {
        'default_property' => 'default DEFAULT value',
        'overwritten_property' => 'default OVERWRITTEN value',
        'console_property' => 'default CONSOLE value'
      }
      expect(@settings.default).to include(expected_default_settings)
    end

    it 'should have getter for custom setting' do
      expect(@settings).to be_respond_to(:default)
      expected_custom_settings = {
        'overwritten_property' => 'overwritten OVERWRITTEN value',
        'console_property' => 'overwritten CONSOLE value'
      }
      expect(@settings.custom).to eq(expected_custom_settings)
    end

    it 'should have getter for all setting' do
      expect(@settings).to be_respond_to(:default)
      expected_all_settings = {
        'default_property' => 'default DEFAULT value',
        'overwritten_property' => 'overwritten OVERWRITTEN value',
        'console_property' => 'console CONSOLE value'
      }

      expect(@settings.all).to include(expected_all_settings)
    end

    it 'should return specified pretty formatted settings for output' do
      # rubocop:disable Lint/EmptyInterpolation
      # rubocop:disable Lint/EmptyExpression
      # rubocop:disable Style/IndentHeredoc
      expected = <<-TXT
#######################################################
#                    All Settings                     #
#######################################################

  api_key                =  ********2333
  api_token              =  ********23ef
  boolean_false          =  default
  boolean_true           =  default
  console_property       =  console CONSOLE value
  default_property       =  default DEFAULT value
  email                  =  user@example.com
  float                  =  default
  int                    =  default
  my_secret              =  ********vqww
  overwritten_property   =  overwritten OVERWRITTEN value
  pass                   =  ********
  passenger_name         =  Ivan Petrov
  password_confirmation  =  ********pass
  reference              =  default
  string                 =  default
  symbol                 =  default
  test1_url              =  http://********.com:********orld@host:80/wd/hub
  test2_url              =  http://********.com@host/wd/hub
  test3_url              =  http://********:********orld@host:80/wd/hub
  test4_url              =  #{}
  test5_url              =  http://host/wd/hub
  user_pass              =  ********orld
  TXT
      # rubocop:enable Lint/EmptyInterpolation
      # rubocop:enable Lint/EmptyExpression
      # rubocop:enable Style/IndentHeredoc
      expect(@settings.as_formatted_text).to eq(expected)
    end

    context 'command line' do
      let(:clone_settings) { settings.class.clone.instance }
      before do
        SexySettings.configure.env_variable_with_options = 'SEXY_SETTINGS'
        ENV['SEXY_SETTINGS'] = 'string=Test, int=1, float=1.09, boolean_true=true,' \
                      ' boolean_false=false, symbol=:foo, reference = ${string}'
      end

      after do
        SexySettings.configure.env_variable_with_options = 'OPTIONS'
      end

      it 'should convert command line string value to String type' do
        expect(clone_settings.string).to eq('Test')
      end

      it 'should convert command line integer value to Integer type' do
        expect(clone_settings.int).to eq(1)
        expect(clone_settings.int).to be_a(Integer)
      end

      it 'should convert command line float value to Float type' do
        expect(clone_settings.float).to eq(1.09)
        expect(clone_settings.float.class).to eq(Float)
      end

      it 'should convert command line true value to TrueClass type' do
        expect(clone_settings.boolean_true).to be_truthy
      end

      it 'should convert command line false value to FalseClass type' do
        expect(clone_settings.boolean_false).to be_falsy
        expect(clone_settings.boolean_false.class).to eq(FalseClass)
      end

      it 'should convert command line symbol value to Symbol type' do
        expect(clone_settings.symbol).to eq(:foo)
      end

      it 'should replace command line reference to correct value' do
        expect(clone_settings.reference).to eq('Test')
      end

      context 'when some settings without defaults' do
        before do
          ENV['SEXY_SETTINGS'] = 'options_without_default1=1, options_without_default2=2'
        end
        it 'raises error related with missing default settings' do
          file = File.expand_path('config.yaml', File.join(File.dirname(__FILE__), '..', '_config'))
          expect { clone_settings }.to raise_error(
            SexySettings::MissingDefaultError,
            "Please specify defaults in '#{file}' config file:\n" \
            "\t\toptions_without_default1: someValue\n" \
            "\t\toptions_without_default2: someValue"
          )
        end
      end
    end

    context 'when unknown setting name' do
      let(:clone_settings) { settings.class.clone.instance }
      it 'raise undefined method error' do
        expect { clone_settings.emial }.to raise_error(
          NoMethodError,
          /undefined method `emial' for SexySettings::Base:#{clone_settings.class}/
        )
      end
    end
  end
  context 'when missing default settings' do
    let(:klass) { SexySettings::Base.clone }
    let(:default_path) { File.expand_path('missing_config.yaml', File.join(File.dirname(__FILE__), '..', '_config')) }
    let(:custom_path) { File.expand_path('overwritten.yaml', File.join(File.dirname(__FILE__), '..', '_config')) }
    before do
      SexySettings.configure do |config|
        config.path_to_default_settings = default_path
        config.path_to_custom_settings = custom_path
        config.path_to_project = File.dirname(__FILE__)
      end
    end

    it 'raise error' do
      expect { klass.instance }.to raise_error(
        Errno::ENOENT,
        "No such file or directory @ rb_sysopen - #{default_path}"
      )
    end
  end

  context 'when missing custom settings' do
    let(:klass) { SexySettings::Base.clone }
    let(:default_path) { File.expand_path('config.yaml', File.join(File.dirname(__FILE__), '..', '_config')) }
    let(:custom_path) { File.expand_path('missing_custom.yaml', File.join(File.dirname(__FILE__), '..', '_config')) }
    before do
      SexySettings.configure do |config|
        config.path_to_default_settings = default_path
        config.path_to_custom_settings = custom_path
        config.path_to_project = File.dirname(__FILE__)
      end
    end

    it 'returns blank custom settings' do
      expect(klass.instance.custom).to eq({})
    end
  end

  context 'when blank settings' do
    let(:klass) { SexySettings::Base.clone }
    let(:default_path) { File.expand_path('blank_default.yml', File.join(File.dirname(__FILE__), '..', '_config')) }
    let(:custom_path) { File.expand_path('blank_custom.yml', File.join(File.dirname(__FILE__), '..', '_config')) }
    before do
      SexySettings.configure do |config|
        config.path_to_default_settings = default_path
        config.path_to_custom_settings = custom_path
        config.path_to_project = File.dirname(__FILE__)
        config.env_variable_with_options = 'OPTS'
      end
    end

    it 'returns blank default and custom settings' do
      expect(klass.instance.default).to eq({})
      expect(klass.instance.custom).to eq({})
    end
  end
end

def settings
  SexySettings::Base.instance
end

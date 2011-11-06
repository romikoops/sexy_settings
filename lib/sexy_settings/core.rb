require 'sexy_settings/base'

module SexySettings
  # Used internally to ensure examples get reloaded between multiple runs in
  # the same process.
  def self.reset
    self.configuration
  end

  # Returns the global configuration object
  def self.configuration
    @configuration ||= Configuration.new
  end

  # Yields the global configuration object
  #
  # == Examples
  #
  # SexySettings.configure do |config|
  #   config.env_variable_with_options = 'OPTIONS'
  # end
  def self.configure
    yield configuration if block_given?
  end
end
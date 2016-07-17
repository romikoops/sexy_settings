# frozen_string_literal: true
module SexySettings
  # This class holds logic sensitive data hiding
  class SensitiveDataProtector
    PROTECTED_PROPERTIES = [/pass(\z|word)/i, /_key\z/i, /secret/i, /token/i].freeze
    URL_REGEXP = %r{\A(https?|ftp):\/\/((?<userpass>(?<user>.*?)(:(?<pass>.*?)|))@)?[^:\/\s]+:([^\/]*)}i
    attr_reader :prop, :value

    def initialize(prop, value)
      @prop = prop
      @value = value.to_s
    end

    def protected_value
      return hide_protected_data_in_url(value) if /_url\z/ =~ prop
      return value unless PROTECTED_PROPERTIES.any? { |el| el =~ prop }
      hide_protected_data(value)
    end

    def hide_protected_data(value)
      return value if value.nil?
      return '********' if value.to_s.size <= 4
      "********#{value.to_s[-4..-1]}"
    end

    def hide_protected_data_in_url(value)
      return value if value.nil? || !(URL_REGEXP =~ value)
      match_data = URL_REGEXP.match(value)
      hide_user_pass(value, match_data)
    end

    def hide_user_pass(value, match_data)
      user = match_data[:user]
      pass = match_data[:pass]
      userpass = match_data[:userpass]
      protected_data = "#{hide_protected_data(user) if user}#{":#{hide_protected_data(pass)}" if pass}"
      value.sub(userpass, protected_data)
    end
  end
end

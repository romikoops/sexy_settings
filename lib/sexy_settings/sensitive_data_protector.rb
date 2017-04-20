module SexySettings
  # This class holds logic sensitive data hiding
  class SensitiveDataProtector
    PROTECTED_PROPERTIES = [/pass(\z|word)/i, /_key\z/i, /secret/i, /token/i].freeze
    URL_REGEXP = %r{\A(?:https?|ftp):\/\/(?:(?<userpass>.+)@)?.*:?(?:[^\/]*)}i
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
      userpass = URL_REGEXP.match(value)[:userpass]
      return value if userpass.nil? || userpass.empty?
      value.sub(userpass, protected_userpass(userpass))
    end

    def protected_userpass(value)
      value.split(':', 2).compact.map(&method(:hide_protected_data)).join(':')
    end
  end
end

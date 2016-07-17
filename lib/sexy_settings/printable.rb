# frozen_string_literal: true
module SexySettings
  # This module holds print methods
  module Printable
    PROTECTED_PROPERTIES = [/pass(\z|word)/i, /_key\z/i, /secret/i, /token/i].freeze
    def as_formatted_text(which = :all)
      props_list = property_list(which)
      max_key_size = props_list.map { |el| el.first.to_s.size }.max
      [
        sharp_line(which),
        title(which),
        sharp_line(which),
        '',
        formatted_properties(props_list, max_key_size),
        ''
      ].join("\n")
    end

    private

    def sharp_line(which)
      '#' * title(which).size
    end

    def title(which)
      "##{' ' * 20}#{which.to_s.capitalize} Settings#{' ' * 21}#"
    end

    def indent(space_count = nil)
      ' ' * (space_count.nil? ? 2 : space_count)
    end

    def property_list(which)
      case which
      when :all then @all
      when :custom then @custom
      when :default then @default
      else ''
      end.to_a
    end

    def formatted_properties(data, max_key_size)
      data.sort_by(&:first).map do |(prop, value)|
        value = hide_protected_data(value) if PROTECTED_PROPERTIES.any? { |el| el =~ prop }
        "#{indent}#{prop}#{indent + indent(max_key_size - prop.to_s.size)}=#{indent}#{value}"
      end
    end

    def hide_protected_data(value)
      return value if value.nil?
      return '********' if value.to_s.size <= 4
      "********#{value.to_s[-4..-1]}"
    end
  end
end

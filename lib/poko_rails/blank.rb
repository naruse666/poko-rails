# frozen_string_literal: true

module PokoRails
  module Blank
    module_function

    def blank?(obj)
      case obj
      when nil
        true
      when false
        true
      when true
        false
      when String
        obj.strip.empty?
      when Array, Hash
        obj.empty?
      else
        if obj.respond_to?(:empty?)
          obj.empty?
        else
          false
        end
      end
    end

    def present?(obj)
      !blank?(obj)
    end
  end
end

class Object
  def blank?
    PokoRails::Blank.blank?(self)
  end

  def present?
    PokoRails::Blank.present?(self)
  end
end

class NilClass
  def blank?
    true
  end

  def present?
    false
  end
end

class FalseClass
  def blank?
    true
  end

  def present?
    false
  end
end

class TrueClass
  def blank?
    false
  end

  def present?
    true
  end
end

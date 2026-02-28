# frozen_string_literal: true

require_relative 'test_helper'

class BlankTest < Minitest::Test
  def test_nil_and_boolean
    refute nil.present?
    assert nil.blank?

    assert false.blank?
    refute false.present?

    refute true.blank?
    assert true.present?
  end

  def test_string
    assert ''.blank?
    assert '  '.blank?
    refute 'a'.blank?
    refute ''.present?
    assert 'a'.present?
  end

  def test_array_hash
    assert [].blank?
    refute [].present?
    refute([1].blank?)
    assert([1].present?)

    assert({}.blank?)
    refute({}.present?)
    refute({ a: 1 }.blank?)
    assert({ a: 1 }.present?)
  end
end

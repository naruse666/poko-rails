# frozen_string_literal: true

require_relative 'test_helper'
class TryTest < Minitest::Test
  def test_try_on_nil
    assert_nil nil.try(:upcase)
  end

  def test_try_on_object
    assert_equal 'A', 'a'.try(:upcase)
  end

  def test_try_missing_method_returns_nil
    assert_nil 'a'.try(:no_such_method_1234)
  end

  def test_try_with_block
    assert_equal(3, 'abc'.try { |s| s.length })
    assert_nil(nil.try { |x| x.to_s })
  end
end

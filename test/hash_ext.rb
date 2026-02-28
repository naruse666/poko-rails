# frozen_string_literal: true

require_relative 'test_helper'
class HashExtTest < Minitest::Test
  def test_slice
    h = { a: 1, b: 2, 'c' => 3 }
    assert_equal({ a: 1 }, h.slice(:a))
    assert_equal({ a: 1, b: 2 }, h.slice(:a, :b))
    assert_equal({}, h.slice(:nope))
    assert_equal({ 'c' => 3 }, h.slice('c'))
  end
end

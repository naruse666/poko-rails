# frozen_string_literal: true

require_relative 'test_helper'

class MattrAccessorTest < Minitest::Test
  module MyMod
  end

  def test_module_attribute
    PokoRails::MattrAccessor.define(MyMod, :flag, default: false)

    assert_equal false, MyMod.flag

    MyMod.flag = true
    assert_equal true, MyMod.flag
  end
end

# frozen_string_literal: true

require_relative 'test_helper'

class ClassAttributeTest < Minitest::Test
  class Parent
  end

  class Child < Parent
  end

  def test_inheritance_and_override
    PokoRails::ClassAttribute.define(Parent, :setting)

    Parent.setting = 1
    assert_equal 1, Parent.setting
    assert_equal 1, Child.setting

    Child.setting = 2
    assert_equal 1, Parent.setting
    assert_equal 2, Child.setting
  end

  def test_instance_reader
    PokoRails::ClassAttribute.define(Parent, :setting2, default: 10)

    assert_equal 10, Parent.new.setting2
  end
end

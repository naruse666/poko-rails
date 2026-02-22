# frozen_string_literal: true

require_relative 'test_helper'

class CattrAccessorTest < Minitest::Test
  class Parent2
  end

  class Child2 < Parent2
  end

  def test_shared_across_inheritance
    PokoRails::CattrAccessor.define(Parent2, :shared, default: 0)

    assert_equal 0, Parent2.shared
    assert_equal 0, Child2.shared

    Child2.shared = 10

    # class_variableは継承階層で共有されやすい (class_attributeとの差分)
    assert_equal 10, Parent2.shared
    assert_equal 10, Child2.shared
  end

  def test_instance_writer_reads_class_value
    PokoRails::CattrAccessor.define(Parent2, :shared2, default: 1)

    obj = Parent2.new
    assert_equal 1, obj.shared2

    obj.shared2 = 7
    assert_equal 7, Parent2.shared2
  end
end

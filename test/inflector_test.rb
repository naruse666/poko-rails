# frozen_string_literal: true

require_relative 'test_helper'

class InflectorTest < Minitest::Test
  def test_underscore_basic
    assert_equal 'users_controller', PokoRails::Inflector.underscore('UsersController')
  end

  def test_underscore_with_module
    assert_equal 'admin/users_controller', PokoRails::Inflector.underscore('Admin::UsersController')
  end

  def test_underscore_acronym_like
    assert_equal 'html_parser', PokoRails::Inflector.underscore('HTMLParser')
  end

  def test_demodulize
    assert_equal 'UsersController', PokoRails::Inflector.demodulize('Admin::UsersController')
    assert_equal 'UsersController', PokoRails::Inflector.demodulize('UsersController')
  end

  def test_deconstantize
    assert_equal 'Admin', PokoRails::Inflector.deconstantize('Admin::UsersController')
    assert_equal '', PokoRails::Inflector.deconstantize('UsersController')
  end

  def test_safe_constantize
    assert_equal String, PokoRails::Inflector.safe_constantize('String')
    assert_nil PokoRails::Inflector.safe_constantize('NoSuchConst1234')
  end
end

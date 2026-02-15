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
end

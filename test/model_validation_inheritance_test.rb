# frozen_string_literal: true

require_relative 'test_helper'

class ModelValidationInheritanceTest < Minitest::Test
  class BaseUser < PokoRails::Model
    validates :name, presence: true
  end

  class AdminUser < BaseUser
  end

  def setup
    @db = PokoRails::Database.connect(':memory:')
    PokoRails::Model.db = @db

    @db.execute(<<~SQL)
      CREATE TABLE base_users (
        id INTEGER PRIMARY KEY,
        name TEXT
      );
    SQL

    @db.execute(<<~SQL)
      CREATE TABLE admin_users (
        id INTEGER PRIMARY KEY,
        name TEXT
      );
    SQL
  end

  def teardown
    @db.close
  end

  def test_validation_inherited
    u = AdminUser.new({})
    ok = u.save
    assert_equal false, ok
    assert_equal ["can't be blank"], u.errors['name']
  end
end

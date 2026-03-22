# frozen_string_literal: true

require_relative 'test_helper'

class ModelValidationTest < Minitest::Test
  class User < PokoRails::Model
    validates :name, presence: true
  end

  def setup
    @db = PokoRails::Database.connect(':memory:')
    PokoRails::Model.db = @db

    @db.execute(<<~SQL)
      CREATE TABLE users (
        id INTEGER PRIMARY KEY,
        name TEXT
      );
    SQL
  end

  def teardown
    @db.close
  end

  def test_invalid_save_returns_false_and_sets_errors
    user = User.new({})
    ok = user.save

    assert_equal false, ok
    assert_nil user.id
    assert_equal ["can't be blank"], user.errors['name']
  end

  def test_valid_save_persists
    user = User.new({ 'name' => 'Alice' })
    ok = user.save

    assert_equal true, ok
    refute_nil user.id
  end
end

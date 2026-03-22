# frozen_string_literal: true

require_relative 'test_helper'

class ModelPersistTest < Minitest::Test
  class User < PokoRails::Model
  end

  def setup
    @db = PokoRails::Database.connect(':memory:')
    PokoRails::Model.db = @db

    @db.execute(<<~SQL)
      CREATE TABLE users(
      id INTEGER PRIMARY KEY,
      name TEXT
      );
    SQL
  end

  def teardown
    @db.close
  end

  def test_create_inserts_and_sets_id
    user = User.create(name: 'Carol')
    refute_nil user.id
    assert_equal 'Carol', user['name']

    fetched = User.find(user.id)
    assert_equal 'Carol', fetched ['name']
  end

  def test_save_updates_existing
    user = User.create(name: 'Alice')
    user['name'] = 'Alice2'
    user.save

    fetched = User.find(user.id)
    assert_equal 'Alice2', fetched['name']
  end
end

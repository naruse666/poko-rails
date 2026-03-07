# frozen_string_literal: true

require_relative 'test_helper'

class ModelWhereTest < Minitest::Test
  class User < PokoRails::Model
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

    @db.execute('INSERT INTO users (name) VALUES (?)', ['Alice'])
    @db.execute('INSERT INTO users (name) VALUES (?)', ['Bob'])
  end

  def teardown
    @db.close
  end

  def test_where_returns_matching_models
    users = User.where(name: 'Alice')
    assert_equal 1, users.size
    assert_equal 'Alice', users.first['name']
  end

  def test_where_returns_empty_when_no_match
    users = User.where(name: 'Nope')
    assert_equal 0, users.size
  end

  def test_where_with_empty_condisions_returns_all
    users = User.where({})
    assert_equal 2, users.size
  end
end

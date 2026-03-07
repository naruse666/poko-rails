# frozen_string_literal: true

require_relative 'test_helper'

class ModelFindTest < Minitest::Test
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
  end

  def teardown
    @db.close
  end

  def test_find_returns_model
    user = User.find(1)
    assert_equal 1, user['id']
    assert_equal 'Alice', user['name']
  end

  def test_find_raises_when_missing
    assert_raises(PokoRails::RecordNotFound) do
      User.find(999)
    end
  end
end

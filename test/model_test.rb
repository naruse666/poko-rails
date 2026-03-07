# frozen_string_literal: true

require_relative 'test_helper'

class ModelTest < Minitest::Test
  class User < PokoRails::Model
  end

  def test_table_name
    assert_equal 'users', User.table_name
  end

  def test_db_set_and_get
    db = PokoRails::Database.connect(':memory:')
    PokoRails::Model.db = db

    assert_same db, PokoRails::Model.db

    db.close
  end
end

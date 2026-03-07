# frozen_string_literal: true

require_relative 'test_helper'
class DatabaseTest < Minitest::Test
  def test_connect_and_select
    db = PokoRails::Database.connect(':memory:')
    rows = db.execute('SELECT 1 AS one')

    # result_as_hash = true なのでHashを含む配列になる
    assert_equal 1, rows.size
    assert_equal 1, rows[0]['one']

    db.close
  end
end

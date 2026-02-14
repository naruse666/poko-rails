# frozen_string_literal: true

require_relative 'test_helper'

class RouterTest < Minitest::Test
  include Rack::Test::Methods
  include TestApp

  def test_users_show
    get 'users/123'

    assert last_response.ok?
    assert_equal "id=123\n", last_response.body
  end

  def test_query_param
    get 'users/123?q=q_param'

    assert last_response.ok?
    assert_equal "id=123, q=q_param\n", last_response.body
  end

  def test_not_found
    get '/nope'

    assert_equal 404, last_response.status
  end
end

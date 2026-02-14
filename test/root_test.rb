# frozen_string_literal: true

require_relative 'test_helper'

class RootTest < Minitest::Test
  include Rack::Test::Methods
  include TestApp

  def test_root
    get '/'
    assert last_response.ok?
    assert_equal "home\n", last_response.body
  end
end

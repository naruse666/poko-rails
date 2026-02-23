# frozen_string_literal: true

require_relative 'test_helper'

class NotificationsTest < Minitest::Test
  def test_subscribe_and_instrument_string
    events = []

    token = PokoRails::Notifications.subscribe('demo.event') do |name, start, finish, id, payload|
      events << [name, start, finish, id, payload]
    end

    PokoRails::Notifications.instrument('demo.event', foo: 1) { :ok }

    assert_equal 1, events.size
    name, start, finish, id, payload = events.first

    assert_equal 'demo.event', name
    assert start < finish
    assert_kind_of String, id
    assert_equal({ foo: 1 }, payload)

    PokoRails::Notifications.unsubscribe(token)
  end

  def test_subscribe_regex
    events = []
    token = PokoRails::Notifications.subscribe(/\Ademo\./) { |*args| events << args }

    PokoRails::Notifications.instrument('demo.a') {}
    PokoRails::Notifications.instrument('other.a') {}

    assert_equal 1, events.size

    PokoRails::Notifications.unsubscribe(token)
  end

  def test_instrument_records_exception_in_payload
    events = []
    token = PokoRails::Notifications.subscribe('demo.err') { |*args| events << args }

    assert_raises(RuntimeError) do
      PokoRails::Notifications.instrument('demo.err') { raise 'boom' }
    end

    payload = events.first.last
    assert_equal %w[RuntimeError boom], payload[:exception]

    PokoRails::Notifications.unsubscribe(token)
  end
end

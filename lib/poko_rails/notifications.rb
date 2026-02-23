# frozen_string_literal: true

require 'securerandom'

module PokoRails
  module Notifications
    Subscriber = Struct.new(:pattern, :block, keyword_init: true)

    @subscribers = []

    module_function

    def subscribe(pattern, &block)
      raise ArgumentError, 'block is required' unless block

      @subscribers << Subscriber.new(pattern: pattern, block: block)
      block
    end

    def unsubscribe(token)
      @subscribers.reject! { |s| s.block == token }
    end

    # ActiveSupport::Notifications 風の引数
    # (name, start, finish, id, payload)
    def instrument(name, payload = {})
      start = monotonic_time
      id = SecureRandom.hex(8)

      result = if block_given?
                 yield(payload)
               else
                 nil
               end

      finish = monotonic_time
      publish(name, start, finish, id, payload)
      result
    rescue StandardError => e
      finish = monotonic_time
      payload = payload.dup
      payload[:exception] = [e.class.name, e.message]
      publish(name, start, finish, id, payload)
      raise
    end

    def publish(name, start, finish, id, payload)
      @subscribers.each do |s|
        next unless match?(s.pattern, name)

        s.block.call(name, start, finish, id, payload)
      end
    end

    def match?(pattern, name)
      case pattern
      when String
        pattern == name
      when Regexp
        pattern.match?(name)
      else
        false
      end
    end

    def monotonic_time
      Process.clock_gettime(Process::CLOCK_MONOTONIC)
    end
  end
end

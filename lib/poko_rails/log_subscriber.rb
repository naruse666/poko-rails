# frozen_string_literal: true

module PokoRails
  class LogSubscriber
    def self.attach!
      Notifications.subscribe(/\A(router|controller)\./) do |name, start, finish, _id, payload|
        duration_ms = ((finish - start) * 1000.0)
        msg = +"[#{name}] #{format('%.2f', duration_ms)}ms "

        # payloadを整形
        msg << payload.map { |k, v| "#{k}=#{v.inspect}" }.join(' ') if payload && !payload.empty?
        $stdout.puts(msg)
      end
    end
  end
end

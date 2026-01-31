# frozen_string_literal: true

module PokoRails
  class Application
    def call(env)
      [
        200,
        {
          'content-type' => 'text/plain; charset=utf-8'
        },
        ["poko-rails: hello\n"]
      ]
    end
  end
end

# frozen_string_literal: true

module PokoRails
  class Router
    def initialize(route_set)
      @route_set = route_set
    end

    def call(env)
      method = env['REQUEST_METHOD']
      path = env['PATH_INFO']

      matched = @route_set.routes.any? do |r|
        r.http_method == method && r.path == path
      end

      if matched
        [
          200, { 'content-type' => 'text/plain; charset=utf-8' }, ["poko-rails: hello\n"]
        ]
      else
        [
          404, { 'content-type' => 'text/plain; charset=utf-8' }, ["Not Found\n"]
        ]
      end
    end
  end
end

# frozen_string_literal: true

module PokoRails
  class Router
    def initialize(route_set)
      @route_set = route_set
    end

    def call(env)
      method = env['REQUEST_METHOD']
      path = env['PATH_INFO']

      route = @route_set.routes.find do |r|
        r.http_method == method && r.path == path
      end

      return not_found if route.nil?

      puts route
      [
        200, { 'content-type' => 'text/plain; charset=utf-8' }, ["to=#{route.to}\n"]
      ]
    end

    private

    def not_found
      [
        404, { 'content-type' => 'text/plain; charset=utf-8' }, ["Not Found\n"]
      ]
    end
  end
end

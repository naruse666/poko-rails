# frozen_string_literal: true

module PokoRails
  class RouteSet
    Route = Struct.new(:http_method, :path, :to, keyword_init: true)

    def initialize
      @routes = []
    end

    def draw(&block)
      instance_eval(&block) if block
      self # メソッドチェーンを可能にするself
    end

    def get(path, to:)
      @routes << Route.new(http_method: 'GET', path: path, to: to)
      self
    end

    def routes
      @routes.dup
    end
  end
end

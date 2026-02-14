# frozen_string_literal: true

module PokoRails
  class RouteSet
    Route = Struct.new(:http_method, :path, :to, :pattern, :param_names, keyword_init: true)

    def initialize
      @routes = []
    end

    def draw(&block)
      instance_eval(&block) if block
      self # メソッドチェーンを可能にするself
    end

    def get(path, to:)
      pattern, param_names = compile(path)
      @routes << Route.new(http_method: 'GET', path: path, to: to, pattern: pattern, param_names: param_names)
      self
    end

    def routes
      @routes.dup
    end

    private

    # '/users/:id' -> [/^\/users\/([^\/]+)$/, ["id"]]
    def compile(path)
      names = []

      rest = path.sub(%r{\A/}, '')
      segments = rest.empty? ? [] : rest.split('/')

      regex = segments.map do |seg|
        if seg.start_with?(':')
          names << seg.delete_prefix(':')
          '([^/]+)'
        else
          Regexp.escape(seg)
        end
      end.join('/')

      pattern = regex.empty? ? %r{\A/\z} : Regexp.new("^/#{regex}$")
      [pattern, names]
    end
  end
end

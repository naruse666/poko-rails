# frozen_string_literal: true

module PokoRails
  class Router
    def initialize(route_set)
      @route_set = route_set
    end

    def call(env)
      method = env['REQUEST_METHOD']
      path = env['PATH_INFO']

      route, path_params = find_route(method, path)
      return not_found if route.nil?

      controller_name, action_name = route.to.split('#', 2)
      controller_class = controller_class_for(controller_name)

      controller = controller_class.new(env, path_params)
      controller.process(action_name)
    rescue NameError
      # controllerが見つからない/actionがない
      not_found
    rescue StandardError => e
      internal_error(e)
    end

    private

    def find_route(method, path)
      @route_set.routes.find do |r|
        next unless r.http_method == method

        m = r.pattern.match(path)
        next unless m

        params = {}
        r.param_names.each_with_index { |name, idx| params[name] = m.captures[idx] }
        return [r, params]
      end
      [nil, {}]
    end

    def controller_class_for(controller_name)
      klass = "#{Inflector.camelize(controller_name)}Controller"
      Inflector.constantize(klass)
    end

    def not_found
      [
        404, { 'content-type' => 'text/plain; charset=utf-8' }, ["Not Found\n"]
      ]
    end

    def internal_error(e)
      body = +"Internal Server Error\n"
      body << "#{e.class}: #{e.message}\n"
      [500, { 'content-type' => 'text/plain; charset=utf-8' }, [body]]
    end
  end
end

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

      controller_name, action_name = route.to.split('#', 2)
      controller_class = controller_class_for(controller_name)

      controller = controller_class.new(env)
      controller.process(action_name)
    rescue NameError, NoMethodError => e
      puts "#{e}"
      # controllerが見つからない/actionがない
      not_found
    end

    private

    def controller_class_for(controller_name)
      klass = "#{Inflector.camelize(controller_name)}Controller"
      Inflector.constantize(klass)
    end

    def not_found
      [
        404, { 'content-type' => 'text/plain; charset=utf-8' }, ["Not Found\n"]
      ]
    end
  end
end

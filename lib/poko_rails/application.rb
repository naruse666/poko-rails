# frozen_string_literal: true

module PokoRails
  class Application
    def routes
      @routes ||= RouteSet.new
    end

    def router
      @router ||= Router.new(routes)
    end

    def call(env)
      router.call(env)
    end
  end
end

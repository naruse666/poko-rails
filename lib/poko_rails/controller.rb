# frozen_string_literal: true

require 'rack/request'

module PokoRails
  class Controller
    def initialize(env, path_params = {})
      @env = env
      @request = Rack::Request.new(env)

      @path_params = stringify_keys(path_params)

      @status = 200
      @headers = { 'content-type' => 'text/plain; charset=utf-8' }
      @body_parts = []
    end

    attr_reader :request

    def params
      @request.params.merge(@path_params)
    end

    def process(action_name)
      return [404, { 'content-type' => 'text/plain; charset=utf-8' }, ["Not Found\n"]] unless respond_to?(action_name)

      public_send(action_name)

      # actionがrenderを呼ばない場合でもRack互換で返す
      [@status, @headers, @body_parts.empty? ? [''] : @body_parts]
    end

    def render(plain:, status: 200, content_type: 'text/plain; charset=utf-8')
      @status = status
      @headers['content-type'] = content_type
      @body_parts = [plain.to_s]
      nil
    end

    private

    def stringify_keys(h)
      h.each_with_object({}) { |(k, v), acc| acc[k.to_s] = v }
    end
  end
end

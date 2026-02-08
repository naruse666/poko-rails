# frozen_string_literal: true

module PokoRails
  class Controller
    def initialize(env)
      @env = env
      @status = 200
      @headers = { 'content-type' => 'text/plain; charset=utf-8' }
      @body_parts = []
      @rendered = false
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
      @rendered = true
      nil
    end
  end
end

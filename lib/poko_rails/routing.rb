# frozen_string_literal: true

module PokoRails
  class RouteSet
    def draw(&block)
      instance_eval(&block) if block
      self # メソッドチェーンを可能にするself
    end
  end
end

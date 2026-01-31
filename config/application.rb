# frozen_string_literal: true

require 'poko_rails'

module PokoRails
  def self.application
    @application ||= Application.new
  end
end

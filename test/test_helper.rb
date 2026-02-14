# frozen_string_literal: true

ENV['RACK_ENV'] = 'test'

require 'minitest/autorun'
require 'rack/test'

require_relative '../config/environment'

module TestApp
  def app
    PokoRails.application
  end
end

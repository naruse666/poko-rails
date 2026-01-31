# frozen_string_literal: true

$LOAD_PATH.unshift File.expand_path('lib', __dir__)
require_relative 'lib/poko_rails'

run PokoRails::Application.new

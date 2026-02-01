# frozen_string_literal: true

require_relative 'boot'
require_relative 'application'

Dir[File.expand_path('../app/controllers/**/*.rb', __dir__)].sort.each { |f| require f }
require_relative 'routes'

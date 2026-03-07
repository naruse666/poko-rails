# frozen_string_literal: true

Dir.glob(File.join(__dir__, '**/*.rb')).each do |file|
  require file
end

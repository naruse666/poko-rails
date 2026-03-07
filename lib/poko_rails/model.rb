# frozen_string_literal: true

module PokoRails
  class Model
    class << self
      attr_writer :db

      def db
        @db || raise('PokoRails::Model.db is not set')
      end

      def table_name
        # User -> user -> users
        base = Inflector.underscore(name)
        Inflector.pluralize(base)
      end
    end
  end
end

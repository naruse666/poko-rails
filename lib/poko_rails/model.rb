# frozen_string_literal: true

module PokoRails
  class RecordNotFound < StandardError; end

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

      def find(id)
        rows = db.execute("SELECT * FROM #{table_name} WHERE id = ? LIMIT 1", [id])
        row = rows.first
        raise RecordNotFound, "Couldn't find #{name} with id=#{id}" unless row

        new(row)
      end

      def initialize(attrs = {})
        # sqlite3 results_as_hash=true の行は 0,1,... の数値キーも含むので除外
        @attributest = attrs.each_with_object({}) do |(k, v), acc|
          next if k.is_a?(Integer)

          acc[k.to_s] = v
        end
      end

      attr_reader :attributes

      def [](key)
        @attributest[key.to_s]
      end
    end
  end
end

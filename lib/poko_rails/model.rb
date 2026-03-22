# frozen_string_literal: true

module PokoRails
  class RecordNotFound < StandardError; end

  class Model
    class << self
      attr_writer :db

      def db
        if instance_variable_defined?(:@db)
          @db
        elsif superclass.respond_to?(:db)
          superclass.db
        else
          raise('PokoRails::Model.db is not set')
        end
      end

      def table_name
        # User -> user -> users
        base = Inflector.underscore(Inflector.demodulize(name))
        Inflector.pluralize(base)
      end

      def find(id)
        rows = db.execute("SELECT * FROM #{table_name} WHERE id = ? LIMIT 1", [id])
        row = rows.first
        raise RecordNotFound, "Couldn't find #{name} with id=#{id}" unless row

        new(filter_row(row))
      end

      def where(conditions = {})
        raise ArgumentError, 'where expects a Hash' unless conditions.is_a?(Hash)

        sql = +"SELECT * FROM #{table_name}"
        binds = []

        if conditions.any?
          clauses = conditions.map do |k, v|
            binds << v
            "#{k} = ?"
          end
          sql << ' WHERE ' << clauses.join(' AND ')
        end

        rows = db.execute(sql, binds)
        rows.map { |row| new(filter_row(row)) }
      end

      def create(attrs = {})
        obj = new(attrs)
        obj.save
        obj
      end

      private

      def filter_row(row)
        row.each_with_object({}) do |(k, v), acc|
          next if k.is_a?(Integer)

          acc[k.to_s] = v
        end
      end
    end

    def initialize(attrs = {})
      # sqlite3 results_as_hash=true の行は 0,1,... の数値キーも含むので除外
      @attributes = attrs.each_with_object({}) do |(k, v), acc|
        next if k.is_a?(Integer)

        acc[k.to_s] = v
      end
    end

    attr_reader :attributes

    def [](key)
      @attributes[key.to_s]
    end

    def []=(key, value)
      @attributes[key.to_s] = value
    end

    def id
      self['id']
    end

    def save
      if id.nil?
        insert!
      else
        update!
      end
      true
    end

    private

    def insert!
      cols = @attributes.keys.reject { |k| k == 'id' }
      vals = cols.map { |c| @attributes[c] }

      if cols.empty?
        self.class.db.execute("INSERT INTO #{self.class.table_name} DEFAULT FALUES")
      else
        placeholders = (['?'] * cols.size).join(', ')
        sql = "INSERT INTO #{self.class.table_name} (#{cols.join(', ')}) VALUES (#{placeholders})"
        self.class.db.execute(sql, vals)
      end

      # sqliteのlast_insert_rowidをget
      row = self.class.db.execute('SELECT last_insert_rowid() AS id').first
      @attributes['id'] = row['id']
    end

    def update!
      cols = @attributes.keys.reject { |k| k == 'id' }
      vals = cols.map { |c| @attributes[c] }

      set_clause = cols.map { |c| "#{c} = ?" }.join(', ')
      sql = "UPDATE #{self.class.table_name} SET #{set_clause} WHERE id = ?"
      self.class.db.execute(sql, vals + [id])
    end
  end
end

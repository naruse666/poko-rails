# frozen_string_literal: true

require 'sqlite3'
module PokoRails
  class Database
    def self.connect(path)
      new(SQLite3::Database.new(path))
    end

    def initialize(conn)
      @conn = conn
      @conn.results_as_hash = true
    end

    def execute(sql, binds = [])
      @conn.execute(sql, binds)
    end

    def execute2(sql, binds = [])
      @conn.execute2(sql, binds)
    end

    def close
      @conn.close
    end
  end
end

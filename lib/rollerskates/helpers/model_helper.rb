require 'sqlite3'

module Rollerskates
  class ModelHelper
    @@db ||= SQLite3::Database.new File.join("db", "app.db")

    def update_query
      "UPDATE #{table_name} SET #{placeholders_for_update} WHERE id = ?"
    end

    def table_name
      self.class.to_s.downcase.pluralize
    end

    def model_name
      self.class
    end

    def self.method_missing(method, *args)
      new.send(method, *args)
    end

    def all_columns
      @all_columns ||= @@db.prepare "SELECT * FROM #{table_name}"
      @all_columns.columns.map &:to_sym
    end

    def method_missing(method, *args)
      @model.send(method, *args)
    end

    def self.all_columns
      self.new.all_columns
    end
  end
end

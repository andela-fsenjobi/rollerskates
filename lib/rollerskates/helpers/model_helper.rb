require 'sqlite3'

module Rollerskates
  class ModelHelper
    @@db = SQLite3::Database.new File.join("db", "app.db")
    
    def update_query
      <<SQL
UPDATE "#{table_name}"
SET title = ?, body = ?
WHERE id = ?
SQL
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
      sql = @@db.prepare "SELECT * FROM #{table_name}"
      sql.columns.map &:to_sym
    end

    def get_values
      columns = all_columns
      columns.delete(:id)
      columns.delete(:created_at)
      columns.map { |method| self.send(method) }
    end

    def get_columns
      columns = all_columns
      columns.delete(:id)
      columns.delete(:created_at)
      columns
    end

    def get_values_for_update
      get_values << send(:id)
    end

    def get_columns_for_update
      columns = get_columns
      columns.map { |column| column.to_s + ' = ?' }.join(", ")
    end

    def get_columns_for_new
      columns = all_columns
      columns.delete(:id)
      columns.join(", ")
    end

    def get_values_for_new
      columns = all_columns
      columns.delete(:id)
      attributes = columns
      attributes.map { |method| self.send(method) }
    end

    def method_missing(method, *args)
      @model.send(method, *args)
    end

    def self.all_columns
      self.new.all_columns
    end
  end
end

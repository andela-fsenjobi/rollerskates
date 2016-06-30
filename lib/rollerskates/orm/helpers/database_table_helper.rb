require "sqlite3"

module Rollerskates
  module DatabaseTableHelper
    def table_name
      to_s.downcase.pluralize
    end

    def database
      @db ||= SQLite3::Database.new File.join("db", "app.db")
    end

    def model_name
      to_s.downcase
    end

    def all_columns
      columns = database.prepare "SELECT * FROM #{table_name}"
      columns.columns.map(&:to_sym)
    end
    
    private

    def add_property(property)
      @properties ||= [
        "id integer PRIMARY KEY AUTOINCREMENT",
        "created_at datetime NOT NULL",
        "updated_at datetime NOT NULL"
      ]
      @properties << property
    end

    def property(field, options)
      add_property "#{field} #{parse_constraints(options)}"
    end

    def create_table
      query = "CREATE TABLE IF NOT EXISTS #{table_name}\
              (#{@properties.join(', ')})"
      database.execute(query)

      all_columns.each { |var| attr_accessor var }
    end

    def parse_constraints(constraints)
      attributes = ""
      constraints.each do |attr, value|
        attributes += send(attr.to_s, value)
      end

      attributes
    end

    def type(value)
      "#{value.to_s.upcase} "
    end

    def primary_key(value)
      return "PRIMARY KEY " if value
      " "
    end

    def nullable(value)
      return "NOT NULL " if value
      "NULL "
    end

    def default(value)
      "DEFAULT `#{value}` "
    end

    def auto_increment(value)
      "AUTOINCREMENT " if value
    end
  end
end

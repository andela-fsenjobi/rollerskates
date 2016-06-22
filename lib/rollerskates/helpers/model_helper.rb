require "sqlite3"

module Rollerskates
  class ModelHelper
    class << self; attr_accessor :properties, :db; end

    def database
      @db ||= SQLite3::Database.new File.join("db", "app.db")
    end

    def add_property(property)
      self.class.properties ||= [
        "id integer PRIMARY KEY AUTOINCREMENT",
        "created_at datetime NOT NULL",
        "updated_at datetime NOT NULL"
      ]
      self.class.properties << property
    end

    def self.property(field, options)
      new.add_property "#{field} #{parse_constraints(options)}"
    end

    def self.belongs_to(table)
      parent_model = table.to_s.camelize.constantize
      parent_table = table.to_s.pluralize
      define_method(table) do
        sql = "SELECT * FROM #{parent_table} WHERE id = ?"
        data = database.execute sql, send("#{table}_id")
        data.flatten!
        self.class.row_to_object(data, parent_model)
      end
    end

    def self.has_many(table)
      model = table.to_s.camelize.constantize
      child_table = table.to_s.pluralize
      parent_model = model_name.to_s.downcase
      define_method(child_table) do
        sql = "SELECT * FROM #{child_table} WHERE `#{parent_model}_id` = ?"
        data = database.execute sql, id
        data.map do |row|
          self.class.row_to_object(row, model)
        end
      end
    end

    def self.create_table
      query = "CREATE TABLE IF NOT EXISTS #{table_name}\
              (#{properties.join(', ')})"
      database.execute(query)

      all_columns.each { |var| attr_accessor var }
    end

    def self.parse_constraints(constraints)
      attributes = ""
      constraints.each do |attr, value|
        attributes += send(attr.to_s, value)
      end

      attributes
    end

    def self.type(value)
      "#{value.to_s.upcase} "
    end

    def self.primary_key(value)
      return "PRIMARY KEY " if value
      " "
    end

    def self.nullable(value)
      return "NOT NULL " if value
      "NULL "
    end

    def self.default(value)
      "DEFAULT `#{value}` "
    end

    def self.auto_increment(value)
      "AUTOINCREMENT " if value
    end

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
      @all_columns = database.prepare "SELECT * FROM #{table_name}"
      @all_columns.columns.map(&:to_sym)
    end

    def method_missing(method, *args)
      @model.send(method, *args)
    end

    def self.all_columns
      new.all_columns
    end
  end
end

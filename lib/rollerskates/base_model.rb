require "sqlite3"

module Rollerskates
  class BaseModel
    @@db = SQLite3::Database.new File.join("db", "app.db")
    def initialize(values = {})
      all_columns.each_with_index do |column, index|
        instance_variable_set("@#{column.to_s}", nil)
      end
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

    def save
      @model = self
      if id
        @@db.execute(update_query, get_values_for_update)
      else
        @@db.execute "INSERT INTO #{table_name} (title, body, created_at) VALUES (?, ?, ?)",
          title, body, created_at
      end
    end

    def update_query
      <<SQL
UPDATE "#{table_name}"
SET title = ?, body = ?
WHERE id = ?
SQL
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

    def self.all
      data = @@db.execute "SELECT #{all_columns.join(', ')} FROM #{table_name}"
      data.map do |row|
        row_to_object(row)
      end
    end

    def self.find(id)
      data = @@db.execute "SELECT #{all_columns.join(', ')} FROM #{table_name} WHERE id = ?", id
      row_to_object data.flatten
    end

    def destroy
      @@db.execute "DELETE FROM #{table_name} WHERE id = ?", id
    end

    def self.destroy(id)
      @@db.execute "DELETE FROM #{table_name} WHERE id = ?", id
    end

    def self.destroy_all
      @@db.execute "DELETE FROM #{table_name}"
    end

    private

      def self.row_to_object(row)
        model = model_name.new
        all_columns.each_with_index do |attribute, index|
          model.send("#{attribute}=", row[index])
        end
        model
      end
  end
end

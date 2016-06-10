require "rollerskates/helpers/model_helper"

module Rollerskates
  class BaseModel < Rollerskates::ModelHelper
    def initialize(values = {})
      all_columns.each_with_index do |column, index|
        instance_variable_set("@#{column.to_s}", nil)
      end
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

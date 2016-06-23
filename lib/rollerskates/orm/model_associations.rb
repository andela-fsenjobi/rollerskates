module Rollerskates
  class BaseModel < Rollerskates::ModelHelper
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
      child_model = table.to_s.camelize.constantize
      child_table = table.to_s.pluralize
      parent_model = model_name.to_s.downcase
      define_method(child_table) do
        sql = "SELECT * FROM #{child_table} WHERE `#{parent_model}_id` = ?"
        data = database.execute sql, id
        data.map do |row|
          self.class.row_to_object(row, child_model)
        end
      end
    end
  end
end

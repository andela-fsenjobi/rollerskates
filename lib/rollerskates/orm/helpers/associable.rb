module Rollerskates
  module Associable
    def belongs_to(table)
      parent_model = table.to_s.camelize.constantize
      define_method(table) do
        parent_model.find_by(id: send("#{table}_id"))
      end
    end

    def has_many(table)
      child_model = table.to_s.camelize.constantize
      child_table = table.to_s.pluralize
      parent_model = model_name.to_s.downcase
      define_method(child_table) do
        column = "#{parent_model}_id"
        child_model.where(column => id)
      end
    end
  end
end

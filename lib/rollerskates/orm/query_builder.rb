require "rollerskates/orm/helpers/query_helper"

module Rollerskates
  class QueryBuilder
    def initialize(model)
      @model = model
      @columns = []
      @type = :collection
    end

    def select(*select_conditions)
      @select = select_conditions
      self
    end

    def where(where_conditions, object = nil)
      if object
        @type = :object
        limit(1)
      end

      @columns << where_conditions
      self
    end

    def first(number = nil)
      @type = :object unless number
      number ? limit(number) : limit(1)
    end

    def limit(limit_condition = nil)
      @limit = limit_condition if limit_condition
      self
    end

    def offset(offset_condition)
      @offset = offset_condition if offset_condition
      self
    end

    def order(order_conditions)
      @order = order_conditions.to_s
      self
    end

    def count
      @count = true
      execute
      @result.flatten[0].to_i
    end

    def update(update_parameters)
      @update_parameters = update_parameters
      @query = "UPDATE #{table_name} SET \
        #{update_values.join(', ')} WHERE id = #{id}"
      self
    end

    def build(create_parameters)
      @create_parameters = create_parameters
      @query = "INSERT INTO #{table_name} (#{create_columns})\
        VALUES (#{create_values})"
      self
    end

    def destroy(item_id = nil)
      index = item_id ? item_id : id
      @query = "DELETE FROM #{table_name} WHERE id = #{index}"
      execute
      self
    end

    def destroy_all
      @query = "DELETE FROM #{table_name}"
      execute
      self
    end

    def save
      @type = :object
      execute
      data
    end

    private

    include Rollerskates::QueryHelper
  end
end

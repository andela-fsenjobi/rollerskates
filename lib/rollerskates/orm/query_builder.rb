module Rollerskates
  class QueryBuilder
    attr_accessor :query

    def initialize(model)
      @model = model
      @columns = []
      @type = :collection
    end

    def select(*select_conditions)
      @select = select_conditions
      self
    end

    def where(where_conditions)
      @columns << where_conditions
      self
    end

    def find_by(find_conditions)
      @type = :object
      where find_conditions
    end

    def first(number)
      @type = :object if number
      limit number
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

    def query_statement
      sql = "#{select_phrase} #{from_phrase}"
      sql  << where_phrase unless @columns.empty?
      sql  << order_phrase if @order
      sql  << limit_phrase if @limit
      sql  << offset_phrase if @offset

      sql
    end

    def query
      @query
    end

    def update(update_parameters)
      @update_parameters = update_parameters
      @query = "UPDATE #{@model.table_name} SET \
        #{update_values.join(', ')} WHERE id = #{id}"
      self
    end

    def build(create_parameters)
      @create_parameters = create_parameters
      @query = "INSERT INTO #{@model.table_name} (#{create_columns})\
        VALUES (#{create_values})"
      self
    end

    def create_columns
      @create_parameters[:created_at] = Time.now.to_s
      @create_parameters[:updated_at] = Time.now.to_s
      @create_parameters.keys.map{ |column| "'#{column}'" }.join(", ")
    end

    def create_values
      @create_parameters.values.map{ |value| "'#{value}'" }.join(", ")
    end

    def save
      execute
      data
    end

    def reset_result
      @result = ""
    end

    def update_values
      @update_parameters[:updated_at] = Time.now.to_s
      @update_parameters.map { |key, value| key.to_s << " = '#{value}'" }
    end

    def select_phrase
      @select ? "SELECT #{@select.flatten.join(', ')} " : "SELECT * "
    end

    def from_phrase
      "FROM #{@model.table_name}"
    end

    def where_phrase
      string = []
      @columns.uniq.each do |col|
        string << col.map { |key, value| "#{key}" << " = '#{value}'" }
      end
      " WHERE #{string.join(' AND ')}" unless @columns.empty?
    end

    def order_phrase
      " ORDER BY #{@order}" if @order
    end

    def limit_phrase
      " LIMIT #{@limit}" if @limit
    end

    def offset_phrase
      " OFFSET #{@offset}" if @offset
    end

    def execute
      sql = query ? query : query_statement
      @result = @model.database.execute sql
    end

    def data
      execute unless @result
      @data ||= if @type == :collection
                  @result.map { |row| @model.row_to_object(row) }
                elsif @type == :object
                  @model.row_to_object(@result.flatten)
                end
    end

    def method_missing(method, *_args)
      if block_given?
        data.each { |object| yield object }
        return true
      end
      data.send(method)
    end
  end
end

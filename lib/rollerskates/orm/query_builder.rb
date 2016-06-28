module Rollerskates
  class QueryBuilder
    attr_accessor :query

    def initialize(model)
      @model = model
      @columns = []
      @type = :collection
    end

    def table_name
      @model.table_name
    end

    def database
      @model.database
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

    def query_statement
      sql = "#{select_phrase} #{from_phrase}"
      sql  << where_phrase unless @columns.empty?
      sql  << order_phrase if @order
      sql  << limit_phrase if @limit
      sql  << offset_phrase if @offset

      sql
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

    def create_columns
      @create_parameters[:created_at] = Time.now.to_s
      @create_parameters[:updated_at] = Time.now.to_s
      @create_parameters.keys.map { |column| "'#{column}'" }.join(", ")
    end

    def create_values
      @create_parameters.values.map { |value| "'#{value}'" }.join(", ")
    end

    def save
      @type = :object
      execute
      data
    end

    def update_values
      @update_parameters[:updated_at] = Time.now.to_s
      @update_parameters.map { |key, value| key.to_s << " = '#{value}'" }
    end

    def select_phrase
      if @count
        "SELECT COUNT (*)"
      elsif @select
        "SELECT #{@select.flatten.join(', ')} "
      else
        "SELECT * "
      end
    end

    def from_phrase
      "FROM #{table_name}"
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
      @result = database.execute sql
    end

    def data
      execute unless @result
      @data ||= if @type == :collection
                  @result.map { |row| row_to_object(row) }
                elsif @type == :object
                  row_to_object(@result.flatten)
                end
    end

    def method_missing(method, *_args)
      if block_given?
        data.each { |object| yield object }
        return true
      end
      data.send(method)
    end

    def columns
      all_columns = database.prepare query_statement
      all_columns.columns.map(&:to_sym)
    end

    def row_to_object(row)
      object = @model.new
      columns.each_with_index do |attribute, index|
        object.send("#{attribute}=", row[index])
      end
      object
    end
  end
end

module Rollerskates
  module QueryHelper
    private
    
    def table_name
      @model.table_name
    end

    def database
      @model.database
    end

    def query_statement
      sql = "#{select_phrase} #{from_phrase}"
      sql  << where_phrase unless @columns.empty?
      sql  << order_phrase if @order
      sql  << limit_phrase if @limit
      sql  << offset_phrase if @offset

      sql
    end

    def create_columns
      @create_parameters[:created_at] = Time.now.to_s
      @create_parameters[:updated_at] = Time.now.to_s
      @create_parameters.keys.map { |column| "'#{column}'" }.join(", ")
    end

    def create_values
      @create_parameters.values.map { |value| "'#{value}'" }.join(", ")
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
      sql = @query ? @query : query_statement
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
      model_object = @model.new
      columns.each_with_index do |attribute, index|
        model_object.send("#{attribute}=", row[index])
      end
      model_object
    end
  end
end

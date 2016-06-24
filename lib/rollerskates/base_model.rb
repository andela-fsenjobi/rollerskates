require "rollerskates/orm/helpers/model_helper"
require "rollerskates/orm/model_associations"
require "rollerskates/orm/query_builder"

module Rollerskates
  class BaseModel < Rollerskates::ModelHelper
    class << self; attr_accessor :query, :result, :values; end
    def self.select(*columns)
      query.select(columns)
    end

    def self.limit(value)
      query.limit(value)
    end

    def self.where(value)
      query.where(value)
    end

    def self.find(value)
      query.find_by(id: value).limit(1)
    end

    def self.find_by(value)
      key = value.keys.first
      value = value.values.first
      query.find_by(key => value).limit(1)
    end

    def self.first(number = nil)
      query.first(number)
    end

    def self.last(number = 1)
      query.order("id DESC").first(number)
    end

    def self.all
      query
    end

    def self.query
      @query = Rollerskates::QueryBuilder.new self
    end

    def initialize(values = {})
      hash_to_properties(values) unless values.empty?
    end

    def hash_to_properties(hash)
      hash.each do |column, value|
        instance_variable_set("@#{column}", value)
      end
    end

    # def update(hash)
    #   hash_to_properties(hash)
    #   @updated_at = Time.now.to_s
    # end
    #
    def save
      self.class.query.build(to_hash).save
    end

    def to_hash
      object_hash = {}
      instance_variables.each do |property|
        object_hash[property[1..-1].to_sym] = instance_variable_get("#{property}")
      end
      object_hash
    end

    def self.create(create_parameters)
      query.build(create_parameters).save
    end

    class << self
      attr_reader :result
    end

    def self.get_result
      @result = database.execute query.query, values
      get_data
    end

    def self.get_data
      if result.length > 1
        result.map { |row| row_to_object(row) }
      else
        row_to_object(result)
      end
    end

    def self.method_missing(method, *args, &block)
      my_methods = [:database, :table_name, :model_name]
      return new.send(method, *args) if my_methods.include? method
      get_result unless result.respond_to? method
      result.send(method, args, block)
    end

    def destroy
      database.execute "DELETE FROM #{table_name} WHERE id = ?", id
    end

    def self.destroy(id)
      database.execute "DELETE FROM #{table_name} WHERE id = ?", id
    end

    def self.destroy_all
      database.execute "DELETE FROM #{table_name}"
    end

    def self.row_to_object(row, model = model_name)
      object = model.new
      model.all_columns.each_with_index do |attribute, index|
        object.send("#{attribute}=", row[index])
      end
      object
    end
  end
end

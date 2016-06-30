require "rollerskates/orm/helpers/database_table_helper"
require "rollerskates/orm/associable"
require "rollerskates/orm/query_builder"

module Rollerskates
  class BaseModel
    extend Rollerskates::Associable
    extend Rollerskates::DatabaseTableHelper

    def initialize(values = {})
      hash_to_properties(values) unless values.empty?
    end

    def save
      self.class.query.build(to_hash).save
    end

    def self.find(value)
      query.where({id: value}, true)
    end

    def self.find_by(find_conditions)
      query.where(find_conditions, true)
    end

    def self.last(number = nil)
      query.order("id DESC").first(number)
    end

    def self.create(create_parameters)
      query.build(create_parameters).save
    end

    def self.all
      query
    end

    def self.query
      Rollerskates::QueryBuilder.new self
    end

    def self.method_missing(method, *args, &block)
      query.send(method, *args, &block)
    end

    private

      def hash_to_properties(hash)
        hash.each do |column, value|
          instance_variable_set("@#{column}", value)
        end
      end

      def to_hash
        hashed_object = {}
        instance_variables.each do |property|
          hashed_object[property[1..-1].to_sym] =
            instance_variable_get(property.to_s)
        end
        hashed_object
      end
  end
end

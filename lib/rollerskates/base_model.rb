require "rollerskates/orm/helpers/database_table_helper"
require "rollerskates/orm/helpers/associable"
require "rollerskates/orm/query_builder"

module Rollerskates
  class BaseModel
    extend Rollerskates::Associable
    extend Rollerskates::DatabaseTableHelper

    class << self; attr_accessor :query, :properties; end

    def self.find(value)
      query.find_by(id: value).limit(1)
    end

    def self.find_by(value)
      key = value.keys.first
      value = value.values.first
      query.find_by(key => value).limit(1)
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
      @query = Rollerskates::QueryBuilder.new self
    end

    def self.method_missing(method, *args, &block)
      query.send(method, *args, &block)
    end

    def initialize(values = {})
      hash_to_properties(values) unless values.empty?
    end

    def hash_to_properties(hash)
      hash.each do |column, value|
        instance_variable_set("@#{column}", value)
      end
    end

    def save
      self.class.query.build(to_hash).save
    end

    def to_hash
      object_hash = {}
      instance_variables.each do |property|
        object_hash[property[1..-1].to_sym] =
          instance_variable_get(property.to_s)
      end
      object_hash
    end
  end
end

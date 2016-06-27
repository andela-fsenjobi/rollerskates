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

    def self.last(number = nil)
      query.order("id DESC").first(number)
    end

    def self.all
      query
    end

    def self.destroy(id)
      query.destroy(id)
    end

    def self.destroy_all
      query.destroy_all
    end

    def self.count
      query.count
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

    def self.create(create_parameters)
      query.build(create_parameters).save
    end
  end
end

require "erb"
require "tilt"
require "pry"

module Rollerskates
  class ViewObject
    attr_reader :main_object

    def initialize(obj)
      @main_object = obj
    end
    #
    # def method_missing(method, *args)
    #   @main_object.send(method, *args)
    # end
  end

  class BaseController
    def initialize(env)
      @request ||= env
    end

    def get_instance_variables
      hash = {}
      variables = instance_variables
      variables -= [:@request]
      variables.each { |var| hash[var[1..-1].to_sym] = instance_variable_get(var) }
      hash
    end

    def response(body = [], status = 200, header = {})
      @response = Rack::Response.new(body, status, header)
    end

    def get_response
      @response
    end

    def render(*args)
      response(render_template(*args))
    end

    def render_template(view_name, locals={})
      file_name = File.join("app", "views", controller_name, "#{view_name}.erb")
      template = Tilt.new(file_name)
      obj = get_view_object
      template.render obj, locals
    end

    def get_view_object
      obj = ViewObject.new(self)
      get_instance_variables.each do |key, value|
        obj.instance_variable_set("@#{key}", value)
      end
      obj
    end

    def finish(method_name)
      if get_response
        get_response
      else
        render(method_name, locals = {})
        get_response
      end
    end

    def controller_name
      self.class.to_s.gsub(/Controller$/, "").snakize
    end
  end
end

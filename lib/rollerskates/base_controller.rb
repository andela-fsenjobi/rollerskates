require 'erb'
require 'tilt'
require 'pry'

module Rollerskates
  class BaseController
    def initialize(env)
      @request ||= env
    end

    def response(body = [], status = 200, header = { 'Content-type' => 'text/html' })
      @response = Rack::Response.new(body, status, header)
    end

    def redirect_to(path, status: 301)
      response([], status, 'Location' => path)
    end

    def params
      @request.params
    end

    def get_response
      @response
    end

    def render(*args)
      response(render_template(*args))
    end

    def render_template(view_name, locals = {})
      file_name = File.join('app', 'views', controller_name, "#{view_name}.erb")
      template = Tilt.new(file_name)
      template.render self, locals
    end

    def finish(method_name, _status = nil)
      if get_response
        get_response
      else
        render(method_name, locals = {})
        get_response
      end
    end

    def controller_name
      self.class.to_s.gsub(/Controller$/, '').snakize
    end
  end
end

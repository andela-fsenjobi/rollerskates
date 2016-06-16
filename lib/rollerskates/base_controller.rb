require "erb"
require "tilt"

module Rollerskates
  class BaseController
    def initialize(request)
      @request ||= request
    end

    def headers
      {
        html: { "Content-type" => "text/html" }
      }
    end

    def response(body = [], status = 200, header = headers[:html])
      @response = Rack::Response.new(body, status, header)
    end

    def redirect_to(path, status)
      response([], status[:status], "Location" => path)
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
      file_name =
        File.join(APP_ROOT, "app", "views", controller_name, "#{view_name}.erb")
      template = Tilt.new(file_name)
      template.render self, locals
    end

    def finish(method_name, _status = nil)
      render(method_name, {}) unless get_response
      get_response
    end

    def controller_name
      self.class.to_s.gsub(/Controller$/, "").snakize
    end
  end
end

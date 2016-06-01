require "erb"
require "tilt"

module Rollerskates
  class BaseController
    def initialize(env)
      @request ||= env
    end

    def render(view_name, locals={})
      file_name = File.join("app", "views", controller_name, "#{view_name}.erb")
      template = Tilt.new(file_name)
      template.render(locals)
    end

    def controller_name
      self.class.to_s.gsub(/Controller$/, "").snakize
    end
  end
end

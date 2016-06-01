module Rollerskates
  module Routing
    class Router
      def draw(&block)
        instance_eval &block
      end

      create_routes = Proc.new do |method_name|
        define_method(method_name) do |path, to:|
          path = "/#{path}" unless path[0] = '/'
          klass_and_method = controller_and_action_for(to)
          @route_data = { path: path,
                          pattern: pattern_for(path),
                          klass_and_method: klass_and_method
                        }
          endpoints[method_name] << @route_data
        end
      end

      [:get, :post, :put, :patch, :delete].each(&create_routes)

      def default_actions
    		[
    			["index", "get"],
    			["create", "post"],
    			["show", "get", ":id"],
    			["destroy", "delete", ":id"],
    			["update", "put", ":id"],
          ["update", "patch", ":id"]
    		]
    	end

    	def resources(controller_name, options = {})
    	  default_actions.each do |value|
    	  	  path_suffix = value[2] ? "/#{value[2]}" : ""
    	  	  path = "/#{controller_name}#{path_suffix}"
            action = "#{controller_name}##{value[0]}"
            send(value[1], path, to: action)
    	  end
    	end

      def root(to)
        get '/', to: to
      end

      def endpoints
        @endpoints ||= Hash.new { |hash, key| hash[key] = [] }
      end

      private

      def pattern_for(path)
        placeholders = []
        pattern = "#{path}".gsub!(/(:\w+)/) do |match|
          placeholders << match[1..-1].freeze
          "(?<#{placeholders.last}>[^/?#]+)"
        end
        pattern = pattern ? pattern : path
        [/^#{pattern}$/, placeholders]
      end

      def controller_and_action_for(path_to)
        controller_path, action = path_to.split('#')
        controller = "#{controller_path.capitalize}Controller"
        [controller, action.to_sym]
      end
    end
  end
end

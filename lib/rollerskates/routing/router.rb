module Rollerskates
  module Routing
    class Router
      def draw(&block)
        instance_eval &block
      end

      [:get, :post, :put, :patch, :delete].each do |method_name|
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

      def default_actions
    		[
    			[:index, :get],
    			[:create, :post],
    			[:show, :get, :id],
          [:edit, :get, :id],
          [:new, :get],
    			[:destroy, :delete, :id],
    			[:update, :put, :id],
          [:update, :patch, :id]
    		]
    	end

      def resources_only(*options)
        default_actions.select do |arr|
          options.include? arr[0]
        end
      end

      def resources_except(*options)
        default_actions.reject do |arr|
          options.include? arr[0]
        end
      end

    	def resources(controller_name, options = {})
        actions = default_actions
        actions = resources_only(options[:only]) if options[:only]
        actions = resources_except(options[:except]) if options[:except]
    	  actions.each do |value|
  	  	  path_suffix = value[2] ? "/#{value[2]}" : ""
  	  	  path = "/#{controller_name}#{path_suffix}"
          action = "#{controller_name}##{value[0]}"
          send(value[1], path, to: action)
    	  end
    	end

      def root(location)
        get '/', to: location
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

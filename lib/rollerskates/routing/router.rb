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
    			{ action: :index,   method: :get,    placeholder: nil,  suffix: nil     },
    			{ action: :create,  method: :post,   placeholder: nil,  suffix: :create },
          { action: :new,     method: :get,    placeholder: nil,  suffix: :new    },
    			{ action: :show,    method: :get,    placeholder: :id,  suffix: nil     },
          { action: :edit,    method: :get,    placeholder: :id,  suffix: :edit     },
    			{ action: :destroy, method: :delete, placeholder: :id,  suffix: nil     },
    			{ action: :update,  method: :put,    placeholder: :id,  suffix: nil     },
          { action: :update,  method: :patch,  placeholder: :id,  suffix: nil     }
    		]
    	end

      def resources_only(*options)
        default_actions.select do |action:, method:, placeholder:, suffix:|
          options.include? action
        end
      end

      def resources_except(*options)
        default_actions.reject do |action:, method:, placeholder:, suffix:|
          options.include? action
        end
      end

    	def resources(controller_name, options = {})
        actions = default_actions
        actions = resources_only(options[:only]) if options[:only]
        actions = resources_except(options[:except]) if options[:except]
    	  actions.each do |action:, method:, placeholder:, suffix:|
  	  	  suffix = suffix ? "/#{suffix}" : ""
          placeholder = placeholder ? "/:#{placeholder}" : ""
  	  	  path = "/#{controller_name}#{placeholder}#{suffix}"
          action = "#{controller_name}##{action}"
          send(method, path, to: action)
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
        controller = "#{controller_path.camelize}Controller"
        [controller, action.to_sym]
      end
    end
  end
end

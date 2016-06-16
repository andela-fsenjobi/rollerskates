module Rollerskates
  module Routing
    class Router
      def draw(&block)
        instance_eval(&block)
      end

      [:get, :post, :put, :patch, :delete].each do |method_name|
        define_method(method_name) do |path, options|
          path = "/#{path}" unless path[0] == "/"
          klass_and_method = controller_and_action_for(options[:to])
          @route_data = { path: path,
                          pattern: pattern_for(path.dup),
                          klass_and_method: klass_and_method
                        }
          endpoints[method_name] << @route_data
        end
      end

      def default_actions
        [
          { action: :index,   method: :get },
          { action: :create,  method: :post },
          { action: :new,     method: :get, suffix: :new },
          { action: :show,    method: :get, placeholder: :id },
          { action: :edit,    method: :get, placeholder: :id, suffix: :edit },
          { action: :destroy, method: :delete, placeholder: :id },
          { action: :update,  method: :put,    placeholder: :id },
          { action: :update,  method: :patch,  placeholder: :id }
        ]
      end

      def resources_only(*options)
        default_actions.select do |action|
          options.include? action[:action]
        end
      end

      def resources_except(*options)
        default_actions.reject do |action|
          options.include? action[:action]
        end
      end

      def resources(controller_name, options = {})
        actions = resources_only(options[:only]) if options[:only]
        actions ||= resources_except(options[:except]) if options[:except]
        actions ||= default_actions

        actions.each do |routes|
          method = routes[:method]
          suffix = routes[:suffix] ? "/#{routes[:suffix]}" : ""
          placeholder = routes[:placeholder] ? "/:#{routes[:placeholder]}" : ""
          path = "/#{controller_name}#{placeholder}#{suffix}"
          action = "#{controller_name}##{routes[:action]}"
          send(method, path, to: action)
        end
      end

      def root(location)
        get "/", to: location
      end

      def endpoints
        @endpoints ||= Hash.new { |hash, key| hash[key] = [] }
      end

      private

      def pattern_for(path)
        placeholders = []
        pattern = path.to_s.gsub!(/(:\w+)/) do |match|
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

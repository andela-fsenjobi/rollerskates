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

      def actions(options = {})
        return resources_only(options[:only]) if options[:only]
        return resources_except(options[:except]) if options[:except]
        default_actions
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

      def method_path_to(route, controller_name)
        suffix = route[:suffix] ? "/#{route[:suffix]}" : ""
        placeholder = route[:placeholder] ? "/:#{route[:placeholder]}" : ""
        [
          route[:method],
          "/#{controller_name}#{placeholder}#{suffix}",
          "#{controller_name}##{route[:action]}"
        ]
      end

      def resources(controller_name, options = {})
        actions(options).each do |route|
          method, path, action = method_path_to(route, controller_name)
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

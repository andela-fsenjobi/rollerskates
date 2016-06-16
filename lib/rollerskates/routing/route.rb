module Rollerskates
  module Routing
    class Route
      attr_reader :klass_name, :request, :method_name

      def initialize(request, klass_and_method)
        @klass_name, @method_name = klass_and_method
        @request = request
      end

      def klass
        klass_name.constantize
      end

      def dispatch
        response = klass.new(request)
        response.send(method_name)
        response
      end
    end
  end
end

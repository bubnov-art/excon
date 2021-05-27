module Excon
  module Middleware
    class Expects < Excon::Middleware::Base
      def response_call(datum)
        additional_expects = datum[:path].include?('question') && datum[:response][:method] == 'DELETE' ? 404 : 204     
        if datum.has_key?(:expects) && ![*datum[:expects],additional_expects].include?(datum[:response][:status])
          raise(
            Excon::Errors.status_error(
              datum.reject {|key,value| key == :response},
              Excon::Response.new(datum[:response])
            )
          )
        else
          @stack.response_call(datum)
        end
      end
    end
  end
end

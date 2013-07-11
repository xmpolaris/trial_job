require 'faraday'

module RestApi
  module Response
    class ParseJson < Faraday::Response::Middleware

      def parse(body)
        JSON.parse(body, :symbolize_names => true)
      end

      def on_complete(env)
        if respond_to?(:parse) && env[:body]
          env[:body] = parse(env[:body]) unless [301].include?(env[:status])
        end
      end

    end
  end
end

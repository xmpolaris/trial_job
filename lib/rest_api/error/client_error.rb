require 'rest_api/error'

module RestApi
  class Error
    # Raised when RestApi returns a 4xx HTTP status code or there's an error in Faraday
    class ClientError < RestApi::Error

      # Create a new error from an HTTP environment
      #
      # @param response [Hash]
      # @return [RestApi::Error]
      def self.from_response(response={})
        new(response[:body].to_s, response[:response_headers])
      end
    end
  end
end

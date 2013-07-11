require 'faraday'
require 'rest_api/configurable'
require 'rest_api/error/client_error'
require 'rest_api/error/server_error'
require 'rest_api/response/parse_json'
require 'rest_api/response/raise_error'

module RestApi
  module Default
    ENDPOINT = 'http://localhost:3001' unless defined? RestApi::Default::ENDPOINT
    CONNECTION_OPTIONS = {
      :headers => {
        :accept => 'application/json',
      },
      :request => {
        :open_timeout => 5,
        :timeout => 10,
      },
      :ssl => {
        :verify => false
      },
    } unless defined? RestApi::Default::CONNECTION_OPTIONS
    IDENTITY_MAP = false unless defined? RestApi::Default::IDENTITY_MAP
    MIDDLEWARE = Faraday::Builder.new do |builder|
      # Convert request params to "www-form-urlencoded"
      builder.use Faraday::Request::UrlEncoded
      # Parse JSON response body
      builder.use RestApi::Response::ParseJson
      # Handle 4xx server responses
      builder.use RestApi::Response::RaiseError, RestApi::Error::ClientError
      # Handle 5xx server responses
      builder.use RestApi::Response::RaiseError, RestApi::Error::ServerError
      # Set Faraday's HTTP adapter
      builder.adapter Faraday.default_adapter
    end unless defined? RestApi::Default::MIDDLEWARE

    class << self

      # @return [Hash]
      def options
        Hash[RestApi::Configurable.keys.map{|key| [key, send(key)]}]
      end

      # @return [String]
      def api_key
        ENV['REST_API_KEY']
      end

      def endpoint
        ENDPOINT
      end

      def connection_options
        CONNECTION_OPTIONS
      end

      # @note Faraday's middleware stack implementation is comparable to that of Rack middleware.  The order of middleware is important: the first middleware on the list wraps all others, while the last middleware is the innermost one.
      # @see https://github.com/technoweenie/faraday#advanced-middleware-usage
      # @see http://mislav.uniqpath.com/2011/07/faraday-advanced-http/
      # @return [Faraday::Builder]
      def middleware
        MIDDLEWARE
      end

    end
  end
end

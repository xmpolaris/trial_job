require 'faraday'
require 'rest_api/configurable'
require 'rest_api/error/client_error'
require 'rest_api/error/decode_error'

require 'rest_api/api/principals'

module RestApi

  class Client
    include RestApi::Configurable
    include RestApi::API::Principals

    # Initializes a new Client object
    #
    # @param options [Hash]
    # @return [RestApi::Client]
    def initialize(options={})
      RestApi::Configurable.keys.each do |key|
        instance_variable_set(:"@#{key}", options[key] || RestApi.instance_variable_get(:"@#{key}"))
      end

      if @api_key.nil?
        raise(Error::ConfigurationError, "No API-Key provided")
      end
    end

    # Perform an HTTP DELETE request
    def delete(path, params={})
      request(:delete, path, params)
    end

    # Perform an HTTP GET request
    def get(path, params={})
      request(:get, path, params)
    end

    # Perform an HTTP POST request
    def post(path, params={})
      signature_params = params.values.any?{|value| value.respond_to?(:to_io)} ? {} : params
      request(:post, path, params, signature_params)
    end

    # Perform an HTTP PUT request
    def put(path, params={})
      request(:put, path, params)
    end

    private

    def setup_auth(method, path, params, signature_params)
      Proc.new do |proc|
        proc.headers['API-Key'] = @api_key
      end
    end

    def request(method, path, params={}, signature_params=params)
      setup_auth = setup_auth(method, path, params, signature_params)
      connection.send(method.to_sym, path, params, &setup_auth).env
    rescue Faraday::Error::ClientError
      raise RestApi::Error::ClientError
    rescue MultiJson::DecodeError
      raise RestApi::Error::DecodeError
    end

    # Returns a Faraday::Connection object
    #
    # @return [Faraday::Connection]
    def connection
      @connection ||= begin
        connection_options = {:builder => @middleware}
        Faraday.new(@endpoint, @connection_options.merge(connection_options))
      end
    end
  end
end

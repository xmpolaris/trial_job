require 'forwardable'
require 'rest_api/error/configuration_error'

module RestApi
  module Configurable
    extend Forwardable

    attr_writer :api_key
    attr_accessor :endpoint, :connection_options, :middleware
    def_delegator :options, :hash

    class << self

      def keys
        @keys ||= [
          :api_key,
          :endpoint,
          :connection_options,
          :middleware,
        ]
      end

    end

    def configure
      yield self
      validate_credential_type!
      self
    end

    def reset!
      RestApi::Configurable.keys.each do |key|
        instance_variable_set(:"@#{key}", RestApi::Default.options[key])
      end
      self
    end
    alias setup reset!

    private

    # @return [Hash]
    def options
      Hash[RestApi::Configurable.keys.map{|key| [key, instance_variable_get(:"@#{key}")]}]
    end

    def validate_credential_type!
      if @api_key.nil?
        raise(Error::ConfigurationError, "No API-Key provided")
      end

      unless @api_key.is_a?(String)
        raise(Error::ConfigurationError, "Invalid API-Key specified: must be a string.")
      end
    end

  end
end

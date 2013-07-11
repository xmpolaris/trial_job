require 'rest_api/configurable'
require 'rest_api/default'

module RestApi
  attr_writer :api_key
  attr_accessor :endpoint, :connection_options, :identity_map, :middleware

  class << self
    include RestApi::Configurable

    def client
      @client = RestApi::Client.new(options) unless defined?(@client) && @client.hash == options.hash
      @client
    end

    def respond_to_missing?(method_name, include_private=false); client.respond_to?(method_name, include_private); end if RUBY_VERSION >= "1.9"
    def respond_to?(method_name, include_private=false); client.respond_to?(method_name, include_private) || super; end if RUBY_VERSION < "1.9"

    private

    def method_missing(method_name, *args, &block)
      return super unless client.respond_to?(method_name)
      client.send(method_name, *args, &block) unless method_name.to_s == 'reset!'
    end
  end
end

RestApi.setup
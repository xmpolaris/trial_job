require 'rest_api/error'

module RestApi
  class Error
    class ConfigurationError < ::ArgumentError
    end
  end
end

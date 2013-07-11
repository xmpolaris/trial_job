require 'rest_api/error'

module RestApi
  class Error
    # Raised when JSON parsing fails
    class DecodeError < RestApi::Error
    end
  end
end

require 'rest_api/error/client_error'

module RestApi
  class Error
    # Raised when RestApi returns the HTTP status code 401
    class Unauthorized < RestApi::Error::ClientError
      HTTP_STATUS_CODE = 401
    end
  end
end

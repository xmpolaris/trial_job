require 'rest_api/error/server_error'

module RestApi
  class Error
    # Raised when RestApi returns the HTTP status code 500
    class InternalServerError < RestApi::Error::ServerError
      HTTP_STATUS_CODE = 500
      MESSAGE = "Something is technically wrong."
    end
  end
end

module RestApi
  module API
    module Principals

      def principals
        send(:get, '/api/v1/principals/list')[:body][:principals]
      end

    end
  end
end

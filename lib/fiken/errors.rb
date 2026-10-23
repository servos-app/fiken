module Fiken
  module Errors
    class Error < StandardError
      attr_reader :response

      def initialize(message = nil, response: nil)
        @response = response
        super(message)
      end

      def status
        response&.status
      end

      # Kept out of #message: Fiken's wording can echo customer data, and
      # exception messages reach AppSignal.
      def api_message
        response&.error_message
      end
    end

    class ConfigurationError < Error; end

    class ConnectionError < Error; end

    class TimeoutError < Error; end

    class BadRequestError < Error; end

    class AuthenticationError < Error; end

    class ForbiddenError < Error; end

    class NotFoundError < Error; end

    class RateLimitError < Error; end

    class ServerError < Error; end

    class OAuthError < Error
      def error_code
        response&.data&.dig("error")
      end
    end
  end
end

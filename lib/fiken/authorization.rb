module Fiken
  # The OAuth2 authorization code flow for a confidential client.
  class Authorization
    URL = "https://fiken.no/oauth"

    attr_reader :client_id, :redirect_uri

    def initialize(client_id:, client_secret:, redirect_uri: nil, timeout: 30, open_timeout: 10, connection: Connection)
      if [client_id, client_secret].any? { |value| value.to_s.strip.empty? }
        raise Errors::ConfigurationError, "client_id and client_secret are required"
      end

      @client_id = client_id
      @client_secret = client_secret
      @redirect_uri = redirect_uri
      @timeouts = {timeout: timeout, open_timeout: open_timeout}
      @connection = connection
    end

    def authorize_url(state:, code_challenge: nil)
      params = {
        response_type: "code",
        client_id: client_id,
        redirect_uri: redirect_uri,
        state: state,
        code_challenge: code_challenge,
        code_challenge_method: ("S256" if code_challenge)
      }

      "#{URL}/authorize?#{URI.encode_www_form(params.compact)}"
    end

    def exchange_code(code:, state:, code_verifier: nil)
      request_token(
        grant_type: "authorization_code",
        code: code,
        redirect_uri: redirect_uri,
        state: state,
        code_verifier: code_verifier
      )
    end

    def refresh(refresh_token)
      request_token({"refresh_token" => refresh_token}, grant_type: "refresh_token", refresh_token: refresh_token)
    end

    # Revokes the grant itself, so every token issued under it stops working.
    def revoke(access_token)
      request = Net::HTTP::Post.new(URI("#{URL}/revoke"))
      request["Authorization"] = "Bearer #{access_token}"
      perform(request)
    end

    private

    def request_token(defaults = {}, **form)
      request = Net::HTTP::Post.new(URI("#{URL}/token"))
      request.basic_auth(client_id, @client_secret)
      request.set_form_data(form.compact)
      response = perform(request)
      raise Errors::OAuthError.new("Fiken sent no token", response: response) unless response.data.is_a?(Hash)

      Token.from_response(defaults.merge(response.data))
    end

    def perform(request)
      response = @connection.perform(request, **@timeouts)
      return response if response.success?

      raise Errors::OAuthError.new("Fiken responded #{response.status} to #{request.path}", response: response)
    end
  end
end

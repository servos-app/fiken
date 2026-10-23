require_relative "test_helper"

class AuthorizationTest < Minitest::Test
  def setup
    @connection = FakeConnection.new
    @authorization = Fiken::Authorization.new(
      client_id: "servos", client_secret: "secret", redirect_uri: "https://servos.test/fiken", connection: @connection
    )
  end

  def test_requires_client_credentials
    assert_raises(Fiken::Errors::ConfigurationError) do
      Fiken::Authorization.new(client_id: "servos", client_secret: nil, redirect_uri: "https://servos.test/fiken")
    end
    assert_raises(Fiken::Errors::ConfigurationError) do
      Fiken::Authorization.new(client_id: " ", client_secret: "secret")
    end
  end

  def test_authorize_url_asks_for_a_code
    url = URI(@authorization.authorize_url(state: "csrf"))

    assert_equal "https://fiken.no/oauth/authorize", "#{url.scheme}://#{url.host}#{url.path}"
    expected = {
      "response_type" => "code",
      "client_id" => "servos",
      "redirect_uri" => "https://servos.test/fiken",
      "state" => "csrf"
    }
    assert_equal expected, URI.decode_www_form(url.query).to_h
  end

  def test_authorize_url_adds_an_s256_challenge_when_given_one
    query = URI.decode_www_form(URI(@authorization.authorize_url(state: "csrf", code_challenge: "abc")).query).to_h

    assert_equal "abc", query["code_challenge"]
    assert_equal "S256", query["code_challenge_method"]
  end

  def test_exchange_code_trades_the_code_for_a_token_with_basic_auth
    @connection.respond_with(body: token_body)
    before = Time.now

    token = @authorization.exchange_code(code: "one-time", state: "csrf")

    assert_token_request(
      "grant_type" => "authorization_code", "code" => "one-time",
      "redirect_uri" => "https://servos.test/fiken", "state" => "csrf"
    )
    assert_equal "access", token.access_token
    assert_equal "refresh", token.refresh_token
    assert_operator token.expires_at, :>=, before + 86_400
    assert_operator token.expires_at, :<=, Time.now + 86_400
  end

  def test_refresh_trades_a_refresh_token_for_a_new_token
    @connection.respond_with(body: token_body)

    assert_equal "access", @authorization.refresh("old").access_token
    assert_token_request("grant_type" => "refresh_token", "refresh_token" => "old")
  end

  def test_refresh_keeps_the_refresh_token_when_fiken_doesnt_rotate_it
    @connection.respond_with(body: {access_token: "access", expires_in: 86_400})

    assert_equal "old", @authorization.refresh("old").refresh_token
  end

  def test_a_token_response_that_isnt_json_raises_oauth_error
    @connection.respond_with(body: "<html>maintenance</html>")

    assert_raises(Fiken::Errors::OAuthError) { @authorization.refresh("old") }
  end

  def test_a_rejected_grant_raises_oauth_error_with_fikens_error_code
    @connection.respond_with(status: 400, body: {error: "invalid_grant"})

    error = assert_raises(Fiken::Errors::OAuthError) { @authorization.refresh("revoked") }

    assert_equal "invalid_grant", error.error_code
  end

  def test_revoke_sends_the_access_token
    @authorization.revoke("access")

    request = @connection.last_request
    assert_equal "POST", request.method
    assert_equal "https://fiken.no/oauth/revoke", request.uri.to_s
    assert_equal "Bearer access", request["Authorization"]
  end

  private

  def token_body
    {access_token: "access", refresh_token: "refresh", token_type: "bearer", expires_in: 86_400}
  end

  def assert_token_request(form)
    request = @connection.last_request
    assert_equal "POST", request.method
    assert_equal "https://fiken.no/oauth/token", request.uri.to_s
    assert_equal "Basic #{["servos:secret"].pack("m0")}", request["Authorization"]
    assert_equal form, URI.decode_www_form(request.body).to_h
  end
end

require_relative "test_helper"

class TokenTest < Minitest::Test
  def test_expires_after_the_given_lifetime
    now = Time.utc(2026, 10, 4, 12)

    token = Fiken::Token.from_response(
      {"access_token" => "access", "refresh_token" => "refresh", "expires_in" => 86_400}, now: now
    )

    assert_equal Time.utc(2026, 10, 5, 12), token.expires_at
  end
end

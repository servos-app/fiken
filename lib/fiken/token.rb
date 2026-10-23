module Fiken
  Token = Data.define(:access_token, :refresh_token, :expires_at) do
    def self.from_response(data, now: Time.now)
      new(
        access_token: data.fetch("access_token"),
        refresh_token: data.fetch("refresh_token"),
        expires_at: now + data.fetch("expires_in")
      )
    end
  end
end

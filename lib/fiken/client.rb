module Fiken
  # One client per Fiken user. Fiken allows a single concurrent request per
  # user, so share a client between threads only behind a lock.
  #
  #   client = Fiken::Client.new(access_token: token.access_token)
  #   client.companies.paginate.to_a
  #   client.company("fiken-demo-as").invoices.paginate(issueDateGe: "2026-01-01").to_a
  class Client
    URL = "https://api.fiken.no/api/v2"
    PAGE_SIZE = 100

    ERRORS = {
      400 => Errors::BadRequestError,
      401 => Errors::AuthenticationError,
      403 => Errors::ForbiddenError,
      404 => Errors::NotFoundError,
      429 => Errors::RateLimitError
    }.freeze

    def initialize(access_token:, timeout: 30, open_timeout: 10, connection: Connection)
      raise Errors::ConfigurationError, "access_token is required" if access_token.to_s.strip.empty?

      @access_token = access_token
      @timeouts = {timeout: timeout, open_timeout: open_timeout}
      @connection = connection
    end

    def user
      get("/user")
    end

    def companies
      @companies ||= Resources::Companies.new(self, "/companies")
    end

    def company(slug)
      Company.new(self, slug)
    end

    def get(path, params: {})
      request(Net::HTTP::Get, path, params: params)
    end

    def post(path, body: nil, params: {})
      request(Net::HTTP::Post, path, params: params, body: body)
    end

    def put(path, body: nil, params: {})
      request(Net::HTTP::Put, path, params: params, body: body)
    end

    def patch(path, body: nil, params: {})
      request(Net::HTTP::Patch, path, params: params, body: body)
    end

    def delete(path, params: {})
      request(Net::HTTP::Delete, path, params: params)
    end

    def upload(path, file:, filename:, fields: {}, params: {})
      multipart = Multipart.new({filename: filename, **fields}, file: file, filename: filename)

      request(Net::HTTP::Post, path, params: params) do |http_request|
        http_request["Content-Type"] = multipart.content_type
        http_request.body = multipart.body
      end
    end

    def paginate(path, params: {})
      Enumerator.new do |items|
        page = 0

        loop do
          response = get(path, params: params.merge(page: page, pageSize: PAGE_SIZE))
          response.data.each { |item| items << item }
          break if response.last_page?

          page += 1
        end
      end
    end

    private

    def request(type, path, params:, body: nil)
      http_request = build_request(type, uri(path, params), body)
      yield http_request if block_given?

      response = @connection.perform(http_request, **@timeouts)
      return response if response.success?

      message = "Fiken responded #{response.status} to #{type::METHOD} #{path}"
      raise error_class(response.status).new(message, response: response)
    end

    def build_request(type, uri, body)
      http_request = type.new(uri)
      http_request["Authorization"] = "Bearer #{@access_token}"
      http_request["Accept"] = "application/json"
      http_request["X-Request-ID"] = SecureRandom.uuid

      unless body.nil?
        http_request["Content-Type"] = "application/json"
        http_request.body = body.to_json
      end

      http_request
    end

    def uri(path, params)
      uri = URI("#{URL}#{path}")
      uri.query = URI.encode_www_form(params.compact) if params.compact.any?
      uri
    end

    def error_class(status)
      ERRORS.fetch(status) { (status >= 500) ? Errors::ServerError : Errors::Error }
    end
  end
end

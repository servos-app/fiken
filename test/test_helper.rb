require "minitest/autorun"
require "stringio"
require_relative "../lib/fiken"

class FakeConnection
  attr_reader :requests

  def initialize
    @requests = []
    @responses = []
  end

  def respond_with(status: 200, body: "", headers: {})
    @responses << Fiken::Response.new(status: status, body: body.is_a?(String) ? body : body.to_json, headers: headers)
    self
  end

  def perform(request, timeout:, open_timeout:)
    @requests << request
    @responses.shift || Fiken::Response.new(status: 200, body: "")
  end

  def last_request = requests.last
end

module FikenTestHelpers
  def setup
    @connection = FakeConnection.new
    @client = Fiken::Client.new(access_token: "fiken-token", connection: @connection)
    @company = @client.company("demo")
  end

  def last_request = @connection.last_request

  def last_query = URI.decode_www_form(last_request.uri.query.to_s).to_h

  def last_body = JSON.parse(last_request.body)

  def assert_request(method, path, query: {})
    assert_equal method, last_request.method
    assert_equal "/api/v2#{path}", last_request.uri.path
    assert_equal query, last_query
  end

  def assert_company_request(method, path, query: {})
    assert_request(method, "/companies/demo#{path}", query: query)
  end
end

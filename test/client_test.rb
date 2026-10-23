require_relative "test_helper"

class ClientTest < Minitest::Test
  include FikenTestHelpers

  def test_requires_an_access_token
    assert_raises(Fiken::Errors::ConfigurationError) { Fiken::Client.new(access_token: nil) }
    assert_raises(Fiken::Errors::ConfigurationError) { Fiken::Client.new(access_token: "") }
  end

  def test_sends_the_bearer_token_a_request_id_and_json_bodies
    @client.post("/companies/demo/contacts", body: {name: "Fjordhytta"})

    assert_company_request "POST", "/contacts"
    assert_equal "api.fiken.no", last_request.uri.host
    assert_equal "Bearer fiken-token", last_request["Authorization"]
    assert_equal "application/json", last_request["Content-Type"]
    assert_equal "application/json", last_request["Accept"]
    assert_match(/\A\h{8}-/, last_request["X-Request-ID"])
    assert_equal({"name" => "Fjordhytta"}, last_body)
  end

  def test_reads_the_created_id_from_the_location_header
    @connection.respond_with(status: 201, headers: {"Location" => "https://api.fiken.no/api/v2/companies/demo/contacts/42"})

    assert_equal "42", @client.post("/companies/demo/contacts", body: {name: "Fjordhytta"}).created_id
  end

  def test_encodes_query_params_and_drops_nil_ones
    @client.get("/companies/demo/invoices", params: {issueDateGe: "2026-01-01", settled: nil})

    assert_company_request "GET", "/invoices", query: {"issueDateGe" => "2026-01-01"}
  end

  def test_user_returns_the_authenticated_user
    @connection.respond_with(body: {name: "Kari"})

    assert_equal "Kari", @client.user.data["name"]
    assert_request "GET", "/user"
  end

  def test_paginate_walks_every_page
    @connection
      .respond_with(body: [{contactId: 1}], headers: {"Fiken-Api-Page" => "0", "Fiken-Api-Page-Count" => "2"})
      .respond_with(body: [{contactId: 2}], headers: {"Fiken-Api-Page" => "1", "Fiken-Api-Page-Count" => "2"})

    ids = @company.contacts.paginate.map { |contact| contact["contactId"] }

    assert_equal [1, 2], ids
    pages = @connection.requests.map { |request| URI.decode_www_form(request.uri.query).to_h }
    assert_equal [{"page" => "0", "pageSize" => "100"}, {"page" => "1", "pageSize" => "100"}], pages
  end

  def test_upload_posts_the_file_as_multipart_form_data
    @connection.respond_with(status: 201)

    @client.upload("/companies/demo/inbox", file: StringIO.new("%PDF-1.4"), filename: "receipt.pdf")

    assert_company_request "POST", "/inbox"
    assert_match %r{\Amultipart/form-data; boundary=}, last_request["Content-Type"]
    assert_includes last_request.body, "%PDF-1.4"
  end

  def test_maps_error_statuses_to_error_classes
    {
      400 => Fiken::Errors::BadRequestError,
      401 => Fiken::Errors::AuthenticationError,
      403 => Fiken::Errors::ForbiddenError,
      404 => Fiken::Errors::NotFoundError,
      429 => Fiken::Errors::RateLimitError,
      503 => Fiken::Errors::ServerError,
      409 => Fiken::Errors::Error
    }.each do |status, error_class|
      @connection.respond_with(status: status)

      error = assert_raises(error_class) { @company.sales.retrieve(1) }
      assert_equal status, error.status
    end
  end

  def test_keeps_fikens_error_text_out_of_the_exception_message
    @connection.respond_with(status: 400, body: {error_description: "kari@example.com is taken"})

    error = assert_raises(Fiken::Errors::BadRequestError) { @company.contacts.create({}) }

    assert_equal "Fiken responded 400 to POST /companies/demo/contacts", error.message
    assert_equal "kari@example.com is taken", error.api_message
  end
end

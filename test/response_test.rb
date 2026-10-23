require_relative "test_helper"

class ResponseTest < Minitest::Test
  def test_last_page_is_false_while_pages_remain
    refute response(headers: {"Fiken-Api-Page" => "0", "Fiken-Api-Page-Count" => "2"}).last_page?
  end

  def test_last_page_is_true_on_the_final_page
    assert response(headers: {"Fiken-Api-Page" => "1", "Fiken-Api-Page-Count" => "2"}).last_page?
  end

  def test_last_page_is_true_for_an_empty_collection
    assert response(headers: {"Fiken-Api-Page" => "0", "Fiken-Api-Page-Count" => "0"}).last_page?
  end

  def test_last_page_is_true_when_fiken_sends_no_paging_headers
    assert response.last_page?
  end

  def test_reads_headers_whatever_their_case
    response = response(headers: {"fiken-api-page" => "3", "FIKEN-API-RESULT-COUNT" => "301"})

    assert_equal 3, response.page
    assert_equal 301, response.result_count
  end

  def test_error_message_prefers_the_error_description
    assert_equal "Bad date", response(body: {error: "invalid", error_description: "Bad date"}.to_json).error_message
  end

  def test_error_message_falls_back_to_the_message_key
    assert_equal "Bad date", response(body: {message: "Bad date"}.to_json).error_message
  end

  def test_error_message_returns_a_plain_text_body
    assert_equal "Bad Gateway", response(body: "Bad Gateway").error_message
  end

  def test_a_blank_body_has_no_data
    assert_nil response(body: " \n").data
  end

  def test_created_id_is_the_last_segment_of_the_location_header
    location = "https://api.fiken.no/api/v2/companies/demo/inbox/abc-123"

    assert_equal "abc-123", response(headers: {"Location" => location}).created_id
  end

  def test_created_id_is_nil_without_a_location_header
    assert_nil response.created_id
  end

  private

  def response(body: "", headers: {})
    Fiken::Response.new(status: 200, body: body, headers: headers)
  end
end

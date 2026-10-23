require_relative "../test_helper"

class InboxTest < Minitest::Test
  include FikenTestHelpers

  def test_create_uploads_the_document_named_after_its_file
    @company.inbox.create(file: StringIO.new("%PDF"), filename: "receipt.pdf")

    assert_company_request "POST", "/inbox"
    assert_match(/name="name"\r\n\r\nreceipt\.pdf/, last_request.body)
  end
end

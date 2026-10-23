require_relative "../test_helper"

class AttachmentsTest < Minitest::Test
  include FikenTestHelpers

  def test_create_uploads_the_file_with_extra_query_params
    @company.sales.attachments(5).create(file: StringIO.new("%PDF"), filename: "receipt.pdf", attachToSale: true)

    assert_company_request "POST", "/sales/5/attachments", query: {"attachToSale" => "true"}
    assert_includes last_request.body, 'filename="receipt.pdf"'
  end

  def test_delete_removes_the_attachment_by_uuid
    @company.invoices.attachments(5).delete("abc-123")

    assert_company_request "DELETE", "/invoices/5/attachments/abc-123"
  end
end

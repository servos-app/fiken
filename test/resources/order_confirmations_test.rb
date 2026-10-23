require_relative "../test_helper"

class OrderConfirmationsTest < Minitest::Test
  include FikenTestHelpers

  def test_create_invoice_draft_drafts_an_invoice_from_the_confirmation
    @company.order_confirmations.create_invoice_draft(6)

    assert_company_request "POST", "/orderConfirmations/6/createInvoiceDraft"
  end
end

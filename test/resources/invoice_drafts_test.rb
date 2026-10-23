require_relative "../test_helper"

class InvoiceDraftsTest < Minitest::Test
  include FikenTestHelpers

  def test_create_recurring_invoice_turns_the_draft_into_a_recurring_invoice
    @company.invoices.drafts.create_recurring_invoice(4)

    assert_company_request "POST", "/invoices/drafts/4/createRecurringInvoice"
  end
end

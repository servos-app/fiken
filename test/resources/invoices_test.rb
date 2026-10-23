require_relative "../test_helper"

class InvoicesTest < Minitest::Test
  include FikenTestHelpers

  def test_deliver_sends_the_invoice
    @company.invoices.deliver({invoiceId: 8, method: ["email"]})

    assert_company_request "POST", "/invoices/send"
    assert_equal({"invoiceId" => 8, "method" => ["email"]}, last_body)
  end
end

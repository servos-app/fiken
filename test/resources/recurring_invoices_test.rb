require_relative "../test_helper"

class RecurringInvoicesTest < Minitest::Test
  include FikenTestHelpers

  def test_update_lines_replaces_the_lines
    @company.recurring_invoices.update_lines(2, {lines: []})

    assert_company_request "PUT", "/recurringInvoices/2/lines"
  end

  def test_update_frequency_replaces_the_frequency
    @company.recurring_invoices.update_frequency(2, {frequency: "MONTHLY"})

    assert_company_request "PUT", "/recurringInvoices/2/frequency"
  end
end

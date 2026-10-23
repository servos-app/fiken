require_relative "../test_helper"

class TimeEntriesTest < Minitest::Test
  include FikenTestHelpers

  def test_create_invoice_draft_drafts_an_invoice_from_time_entries
    @company.time_entries.create_invoice_draft({timeEntryIds: [1, 2]})

    assert_company_request "POST", "/timeEntries/createInvoiceDraft"
    assert_equal({"timeEntryIds" => [1, 2]}, last_body)
  end
end

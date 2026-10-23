require_relative "../test_helper"

class CreditNotesTest < Minitest::Test
  include FikenTestHelpers

  def test_create_full_credits_a_whole_invoice
    @company.credit_notes.create_full({invoiceId: 8})

    assert_company_request "POST", "/creditNotes/full"
    assert_equal({"invoiceId" => 8}, last_body)
  end

  def test_create_partial_credits_part_of_an_invoice
    @company.credit_notes.create_partial({invoiceId: 8})

    assert_company_request "POST", "/creditNotes/partial"
  end

  def test_deliver_sends_the_credit_note
    @company.credit_notes.deliver({creditNoteId: 2, method: ["email"]})

    assert_company_request "POST", "/creditNotes/send"
  end
end

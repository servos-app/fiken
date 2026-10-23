require_relative "../test_helper"

class DraftsTest < Minitest::Test
  include FikenTestHelpers

  def test_finalize_posts_to_the_documents_create_action
    {
      @company.sales.drafts => "/sales/drafts/4/createSale",
      @company.purchases.drafts => "/purchases/drafts/4/createPurchase",
      @company.credit_notes.drafts => "/creditNotes/drafts/4/createCreditNote",
      @company.offers.drafts => "/offers/drafts/4/createOffer",
      @company.order_confirmations.drafts => "/orderConfirmations/drafts/4/createOrderConfirmation",
      @company.invoices.drafts => "/invoices/drafts/4/createInvoice"
    }.each do |drafts, path|
      drafts.finalize(4)

      assert_company_request "POST", path
    end
  end

  def test_attachments_are_scoped_to_the_draft
    @company.sales.drafts.attachments(4).list

    assert_company_request "GET", "/sales/drafts/4/attachments"
  end
end

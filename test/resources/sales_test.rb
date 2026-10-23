require_relative "../test_helper"

class SalesTest < Minitest::Test
  include FikenTestHelpers

  def test_settle_marks_the_sale_settled_on_a_date
    @company.sales.settle(5, settled_date: "2026-10-01")

    assert_company_request "PATCH", "/sales/5/settled", query: {"settledDate" => "2026-10-01"}
  end

  def test_write_off_books_the_sale_as_a_loss
    @company.sales.write_off(5, {type: "COLLECTION_FAILED", date: "2026-10-01"})

    assert_company_request "PATCH", "/sales/5/writeOff"
    assert_equal({"type" => "COLLECTION_FAILED", "date" => "2026-10-01"}, last_body)
  end

  def test_accruals_are_scoped_to_the_sale
    @company.sales.accruals(5).list

    assert_company_request "GET", "/sales/5/accruals"
  end
end

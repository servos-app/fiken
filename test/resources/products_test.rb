require_relative "../test_helper"

class ProductsTest < Minitest::Test
  include FikenTestHelpers

  def test_sales_report_posts_the_report_specification
    @company.products.sales_report({from: "2026-01-01", to: "2026-09-30"})

    assert_company_request "POST", "/products/salesReport"
    assert_equal({"from" => "2026-01-01", "to" => "2026-09-30"}, last_body)
  end
end

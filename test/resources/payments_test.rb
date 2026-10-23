require_relative "../test_helper"

class PaymentsTest < Minitest::Test
  include FikenTestHelpers

  def test_create_registers_a_payment_on_the_sale
    @company.sales.payments(5).create({amount: 50000})

    assert_company_request "POST", "/sales/5/payments"
    assert_equal({"amount" => 50000}, last_body)
  end

  def test_delete_sends_the_optional_reason
    @company.purchases.payments(5).delete(2, description: "Wrong account")

    assert_company_request "DELETE", "/purchases/5/payments/2", query: {"description" => "Wrong account"}
  end
end

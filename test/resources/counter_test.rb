require_relative "../test_helper"

class CounterTest < Minitest::Test
  include FikenTestHelpers

  def test_retrieve_reads_the_counter
    @connection.respond_with(body: {value: 10004})

    assert_equal 10004, @company.invoices.counter.retrieve.data["value"]
    assert_company_request "GET", "/invoices/counter"
  end

  def test_create_without_a_value_lets_fiken_pick_its_default
    @company.invoices.counter.create

    assert_company_request "POST", "/invoices/counter"
    assert_equal({}, last_body)
  end

  def test_create_with_a_value_starts_the_series_there
    @company.offers.counter.create(value: 500)

    assert_company_request "POST", "/offers/counter"
    assert_equal({"value" => 500}, last_body)
  end
end

require_relative "../test_helper"

class AccountBalancesTest < Minitest::Test
  include FikenTestHelpers

  def test_list_asks_for_balances_on_a_date
    @company.account_balances.list(date: "2026-09-30", fromAccount: 3000)

    assert_company_request "GET", "/accountBalances", query: {"date" => "2026-09-30", "fromAccount" => "3000"}
  end

  def test_retrieve_reads_one_accounts_balance_on_a_date
    @company.account_balances.retrieve("1500:10001", date: "2026-09-30")

    assert_company_request "GET", "/accountBalances/1500:10001", query: {"date" => "2026-09-30"}
  end
end

require_relative "../test_helper"

class JournalEntriesTest < Minitest::Test
  include FikenTestHelpers

  def test_create_posts_a_general_journal_entry
    @company.journal_entries.create({description: "Daily settlement"})

    assert_company_request "POST", "/generalJournalEntries"
  end
end

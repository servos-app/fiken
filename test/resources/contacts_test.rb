require_relative "../test_helper"

class ContactsTest < Minitest::Test
  include FikenTestHelpers

  def test_contact_persons_are_scoped_to_the_contact
    @company.contacts.contact_persons(3).create({name: "Kari"})

    assert_company_request "POST", "/contacts/3/contactPerson"
  end
end

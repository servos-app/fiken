require_relative "test_helper"

class ResourceTest < Minitest::Test
  include FikenTestHelpers

  def test_list_passes_filters_through
    @company.contacts.list(customerNumber: 10001)

    assert_company_request "GET", "/contacts", query: {"customerNumber" => "10001"}
  end

  def test_retrieve_create_and_delete_address_the_member
    @company.products.retrieve(7)
    assert_company_request "GET", "/products/7"

    @company.products.create({name: "Kajak"})
    assert_company_request "POST", "/products"
    assert_equal({"name" => "Kajak"}, last_body)

    @company.products.delete(7)
    assert_company_request "DELETE", "/products/7"
  end

  def test_replaceable_updates_with_put
    @company.contacts.update(3, {name: "Fjordhytta"})

    assert_company_request "PUT", "/contacts/3"
    assert_equal({"name" => "Fjordhytta"}, last_body)
  end

  def test_patchable_updates_with_patch
    @company.projects.update(3, {name: "Sommer"})

    assert_company_request "PATCH", "/projects/3"
    assert_equal({"name" => "Sommer"}, last_body)
  end

  def test_reversible_deletes_by_patching_with_a_reason
    @company.transactions.delete(9, description: "Duplicate")

    assert_company_request "PATCH", "/transactions/9/delete", query: {"description" => "Duplicate"}
  end

  def test_attachable_scopes_attachments_to_the_member
    @company.invoices.attachments(5).list

    assert_company_request "GET", "/invoices/5/attachments"
  end
end

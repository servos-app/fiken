module Fiken
  module Resources
    class Contacts < Resource
      include Listable
      include Retrievable
      include Creatable
      include Replaceable
      include Deletable
      include Attachable

      def contact_persons(contact_id)
        ContactPersons.new(client, at(contact_id, "contactPerson"))
      end
    end
  end
end

module Fiken
  module Resources
    class ContactPersons < Resource
      include Listable
      include Retrievable
      include Creatable
      include Replaceable
      include Deletable
    end
  end
end

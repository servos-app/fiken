module Fiken
  module Resources
    class BankAccounts < Resource
      include Listable
      include Retrievable
      include Creatable
    end
  end
end

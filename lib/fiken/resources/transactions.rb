module Fiken
  module Resources
    class Transactions < Resource
      include Listable
      include Retrievable
      include Reversible
    end
  end
end

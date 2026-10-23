module Fiken
  module Resources
    class Accruals < Resource
      include Listable
      include Retrievable
      include Creatable
      include Deletable
    end
  end
end

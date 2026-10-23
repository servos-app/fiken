module Fiken
  module Resources
    class Activities < Resource
      include Listable
      include Retrievable
      include Creatable
      include Patchable
      include Deletable
    end
  end
end

module Fiken
  module Resources
    class Companies < Resource
      include Listable
      include Retrievable
    end
  end
end

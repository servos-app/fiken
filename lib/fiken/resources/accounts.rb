module Fiken
  module Resources
    class Accounts < Resource
      include Listable
      include Retrievable
    end
  end
end

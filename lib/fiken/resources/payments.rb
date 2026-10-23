module Fiken
  module Resources
    class Payments < Resource
      include Listable
      include Retrievable
      include Creatable

      def delete(id, description: nil)
        client.delete(at(id), params: {description: description})
      end
    end
  end
end

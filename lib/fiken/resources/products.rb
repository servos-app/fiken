module Fiken
  module Resources
    class Products < Resource
      include Listable
      include Retrievable
      include Creatable
      include Replaceable
      include Deletable

      def sales_report(body)
        client.post(at("salesReport"), body: body)
      end
    end
  end
end

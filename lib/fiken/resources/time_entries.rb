module Fiken
  module Resources
    class TimeEntries < Resource
      include Listable
      include Retrievable
      include Creatable
      include Patchable
      include Deletable

      def create_invoice_draft(body)
        client.post(at("createInvoiceDraft"), body: body)
      end
    end
  end
end

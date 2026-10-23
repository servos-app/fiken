module Fiken
  module Resources
    class InvoiceDrafts < Drafts
      def initialize(client, path)
        super(client, path, finalize_as: "createInvoice")
      end

      def create_recurring_invoice(id)
        client.post(at(id, "createRecurringInvoice"))
      end
    end
  end
end

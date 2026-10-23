module Fiken
  module Resources
    class OrderConfirmations < Resource
      include Listable
      include Retrievable

      def create_invoice_draft(id)
        client.post(at(id, "createInvoiceDraft"))
      end

      def counter
        @counter ||= Counter.new(client, at("counter"))
      end

      def drafts
        @drafts ||= Drafts.new(client, at("drafts"), finalize_as: "createOrderConfirmation")
      end
    end
  end
end

module Fiken
  module Resources
    class Invoices < Resource
      include Listable
      include Retrievable
      include Creatable
      include Patchable
      include Attachable

      def deliver(body)
        client.post(at("send"), body: body)
      end

      def counter
        @counter ||= Counter.new(client, at("counter"))
      end

      def drafts
        @drafts ||= InvoiceDrafts.new(client, at("drafts"))
      end
    end
  end
end

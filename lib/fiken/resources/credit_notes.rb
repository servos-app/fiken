module Fiken
  module Resources
    class CreditNotes < Resource
      include Listable
      include Retrievable

      def create_full(body)
        client.post(at("full"), body: body)
      end

      def create_partial(body)
        client.post(at("partial"), body: body)
      end

      def deliver(body)
        client.post(at("send"), body: body)
      end

      def counter
        @counter ||= Counter.new(client, at("counter"))
      end

      def drafts
        @drafts ||= Drafts.new(client, at("drafts"), finalize_as: "createCreditNote")
      end
    end
  end
end

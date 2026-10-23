module Fiken
  module Resources
    class Sales < Resource
      include Listable
      include Retrievable
      include Creatable
      include Reversible
      include Attachable

      # Settles the sale without a payment ("sett til oppgjort uten betaling").
      def settle(id, settled_date:)
        client.patch(at(id, "settled"), params: {settledDate: settled_date})
      end

      def write_off(id, body)
        client.patch(at(id, "writeOff"), body: body)
      end

      def payments(sale_id)
        Payments.new(client, at(sale_id, "payments"))
      end

      def accruals(sale_id)
        Accruals.new(client, at(sale_id, "accruals"))
      end

      def drafts
        @drafts ||= Drafts.new(client, at("drafts"), finalize_as: "createSale")
      end
    end
  end
end

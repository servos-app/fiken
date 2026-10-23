module Fiken
  module Resources
    class Purchases < Resource
      include Listable
      include Retrievable
      include Creatable
      include Reversible
      include Attachable

      def payments(purchase_id)
        Payments.new(client, at(purchase_id, "payments"))
      end

      def accruals(purchase_id)
        Accruals.new(client, at(purchase_id, "accruals"))
      end

      def drafts
        @drafts ||= Drafts.new(client, at("drafts"), finalize_as: "createPurchase")
      end
    end
  end
end

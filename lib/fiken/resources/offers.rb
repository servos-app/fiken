module Fiken
  module Resources
    class Offers < Resource
      include Listable
      include Retrievable

      def deliver(body)
        client.post(at("send"), body: body)
      end

      def counter
        @counter ||= Counter.new(client, at("counter"))
      end

      def drafts
        @drafts ||= Drafts.new(client, at("drafts"), finalize_as: "createOffer")
      end
    end
  end
end

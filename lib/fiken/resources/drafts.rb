module Fiken
  module Resources
    class Drafts < Resource
      include Listable
      include Retrievable
      include Creatable
      include Replaceable
      include Deletable
      include Attachable

      def initialize(client, path, finalize_as:)
        super(client, path)
        @finalize_as = finalize_as
      end

      # Turns the draft into a booked document.
      def finalize(id)
        client.post(at(id, @finalize_as))
      end
    end
  end
end

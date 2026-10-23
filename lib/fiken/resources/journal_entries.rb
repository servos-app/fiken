module Fiken
  module Resources
    class JournalEntries < Resource
      include Listable
      include Retrievable
      include Attachable

      def initialize(client, path, general_path:)
        super(client, path)
        @general_path = general_path
      end

      def create(body)
        client.post(@general_path, body: body)
      end
    end
  end
end

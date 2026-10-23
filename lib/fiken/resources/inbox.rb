module Fiken
  module Resources
    class Inbox < Resource
      include Listable
      include Retrievable
      include Deletable

      def create(file:, filename:, name: filename, description: nil)
        client.upload(path, file: file, filename: filename, fields: {name: name, description: description})
      end
    end
  end
end

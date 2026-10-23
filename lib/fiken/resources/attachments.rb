module Fiken
  module Resources
    class Attachments < Resource
      include Listable

      def create(file:, filename:, **params)
        client.upload(path, file: file, filename: filename, params: params)
      end

      def delete(uuid)
        client.delete(at(uuid))
      end
    end
  end
end

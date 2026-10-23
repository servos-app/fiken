module Fiken
  class Resource
    module Listable
      def list(**params)
        client.get(path, params: params)
      end

      def paginate(**params)
        client.paginate(path, params: params)
      end
    end

    module Retrievable
      def retrieve(id)
        client.get(at(id))
      end
    end

    module Creatable
      def create(body)
        client.post(path, body: body)
      end
    end

    module Replaceable
      def update(id, body)
        client.put(at(id), body: body)
      end
    end

    module Patchable
      def update(id, body)
        client.patch(at(id), body: body)
      end
    end

    module Deletable
      def delete(id)
        client.delete(at(id))
      end
    end

    # Fiken never deletes booked records: the delete endpoint posts a
    # reversing entry and requires a reason.
    module Reversible
      def delete(id, description:)
        client.patch(at(id, "delete"), params: {description: description})
      end
    end

    module Attachable
      def attachments(id)
        Resources::Attachments.new(client, at(id, "attachments"))
      end
    end

    attr_reader :client, :path

    def initialize(client, path)
      @client = client
      @path = path
    end

    private

    def at(*segments)
      [path, *segments].join("/")
    end
  end
end

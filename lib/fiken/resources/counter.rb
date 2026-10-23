module Fiken
  module Resources
    # A document number series. It must exist before the first document of
    # its kind is created; Fiken starts it at 10000 unless given a value.
    class Counter < Resource
      def retrieve
        client.get(path)
      end

      def create(value: nil)
        client.post(path, body: value ? {value: value} : {})
      end
    end
  end
end

module Fiken
  module Resources
    class RecurringInvoices < Resource
      include Listable
      include Retrievable
      include Creatable

      def update_lines(id, body)
        client.put(at(id, "lines"), body: body)
      end

      def update_frequency(id, body)
        client.put(at(id, "frequency"), body: body)
      end

      def jobs(id)
        RecurringInvoiceJobs.new(client, at(id, "jobs"))
      end
    end
  end
end

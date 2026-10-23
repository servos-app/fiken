module Fiken
  module Resources
    class RecurringInvoiceJobs < Resource
      include Creatable

      def update_schedule(job_id, body)
        client.put(at(job_id, "schedule"), body: body)
      end

      def update_recipients(job_id, body)
        client.put(at(job_id, "recipients"), body: body)
      end

      def pause(job_id)
        client.post(at(job_id, "pause"))
      end

      def resume(job_id)
        client.post(at(job_id, "resume"))
      end

      def stop(job_id)
        client.post(at(job_id, "stop"))
      end
    end
  end
end

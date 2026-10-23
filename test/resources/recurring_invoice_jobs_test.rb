require_relative "../test_helper"

class RecurringInvoiceJobsTest < Minitest::Test
  include FikenTestHelpers

  def test_create_adds_a_job_to_the_recurring_invoice
    @company.recurring_invoices.jobs(2).create({sendMethod: "email"})

    assert_company_request "POST", "/recurringInvoices/2/jobs"
  end

  def test_update_schedule_and_update_recipients_replace_the_jobs_settings
    jobs = @company.recurring_invoices.jobs(2)

    jobs.update_schedule(3, {})
    assert_company_request "PUT", "/recurringInvoices/2/jobs/3/schedule"

    jobs.update_recipients(3, {})
    assert_company_request "PUT", "/recurringInvoices/2/jobs/3/recipients"
  end

  def test_pause_resume_and_stop_act_on_the_job
    jobs = @company.recurring_invoices.jobs(2)

    %i[pause resume stop].each do |action|
      jobs.public_send(action, 3)

      assert_company_request "POST", "/recurringInvoices/2/jobs/3/#{action}"
    end
  end
end

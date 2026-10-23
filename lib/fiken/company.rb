module Fiken
  class Company
    attr_reader :client, :slug, :path

    def initialize(client, slug)
      @client = client
      @slug = slug
      @path = "/companies/#{slug}"
    end

    def retrieve
      client.get(path)
    end

    def accounts
      @accounts ||= Resources::Accounts.new(client, at("accounts"))
    end

    def account_balances
      @account_balances ||= Resources::AccountBalances.new(client, at("accountBalances"))
    end

    def activities
      @activities ||= Resources::Activities.new(client, at("activities"))
    end

    def bank_accounts
      @bank_accounts ||= Resources::BankAccounts.new(client, at("bankAccounts"))
    end

    def bank_balances
      @bank_balances ||= Resources::BankBalances.new(client, at("bankBalances"))
    end

    def contacts
      @contacts ||= Resources::Contacts.new(client, at("contacts"))
    end

    def credit_notes
      @credit_notes ||= Resources::CreditNotes.new(client, at("creditNotes"))
    end

    def ehf_documents
      @ehf_documents ||= Resources::EhfDocuments.new(client, at("ehf"))
    end

    def groups
      @groups ||= Resources::Groups.new(client, at("groups"))
    end

    def inbox
      @inbox ||= Resources::Inbox.new(client, at("inbox"))
    end

    def invoices
      @invoices ||= Resources::Invoices.new(client, at("invoices"))
    end

    def journal_entries
      @journal_entries ||= Resources::JournalEntries.new(
        client, at("journalEntries"), general_path: at("generalJournalEntries")
      )
    end

    def offers
      @offers ||= Resources::Offers.new(client, at("offers"))
    end

    def order_confirmations
      @order_confirmations ||= Resources::OrderConfirmations.new(client, at("orderConfirmations"))
    end

    def products
      @products ||= Resources::Products.new(client, at("products"))
    end

    def projects
      @projects ||= Resources::Projects.new(client, at("projects"))
    end

    def purchases
      @purchases ||= Resources::Purchases.new(client, at("purchases"))
    end

    def recurring_invoices
      @recurring_invoices ||= Resources::RecurringInvoices.new(client, at("recurringInvoices"))
    end

    def sales
      @sales ||= Resources::Sales.new(client, at("sales"))
    end

    def time_entries
      @time_entries ||= Resources::TimeEntries.new(client, at("timeEntries"))
    end

    def time_users
      @time_users ||= Resources::TimeUsers.new(client, at("timeUsers"))
    end

    def transactions
      @transactions ||= Resources::Transactions.new(client, at("transactions"))
    end

    private

    def at(segment)
      "#{path}/#{segment}"
    end
  end
end

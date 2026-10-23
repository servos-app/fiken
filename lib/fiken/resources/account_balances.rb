module Fiken
  module Resources
    class AccountBalances < Resource
      def list(date:, **params)
        client.get(path, params: {date: date, **params})
      end

      def paginate(date:, **params)
        client.paginate(path, params: {date: date, **params})
      end

      def retrieve(account_code, date:)
        client.get(at(account_code), params: {date: date})
      end
    end
  end
end

module Customers
  class AccountController < ApplicationController
    def show
      @transactions = customer_transactions
    end

    private

    def customer_transactions
      current_customer
        .sent_transactions
        .or(current_customer.received_transactions)
        .order(created_at: :desc)
    end
  end
end

module Customers
  class AccountController < ApplicationController
    def show
      @transactions = current_customer.transactions
    end
  end
end

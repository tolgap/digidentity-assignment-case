module Customers
  class TransactionsController < ApplicationController
    def new
      @transaction_create_request = TransactionCreateRequest.new
    end

    def create
      if transaction_create_request.valid?
        @transaction = build_transfer_transaction!

        if @transaction.save
          flash[:notice] = "Transaction sent"
          return redirect_to root_path
        end
      end

      flash.now[:alert] = "Transaction failed"
      render :new, status: :unprocessable_entity
    end

    private

    def build_transfer_transaction!
      Transaction.new(
        sender: current_customer,
        receiver: transaction_create_request.receiver,
        amount_cents: transaction_create_request.amount_cents,
        transaction_type: "transfer"
      )
    end

    def transaction_create_request
      @transaction_create_request ||= TransactionCreateRequest.new(create_params)
    end

    def create_params
      params.require(:transaction).permit(
        :base_amount,
        :decimal_amount,
        :currency,
        :account_number,
        :account_holder
      )
    end
  end
end

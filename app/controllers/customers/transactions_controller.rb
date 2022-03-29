module Customers
  class TransactionsController < ApplicationController
    def new
      @transaction_create_request = TransactionCreateRequest.new
    end

    def create
      if transaction_create_request.valid?
        @transaction = transfer_transaction!

        if @transaction.valid?
          flash[:notice] = "Transaction sent"
          return redirect_to root_path
        end
      end

      flash.now[:alert] = "Transaction failed"
      render :new, status: :unprocessable_entity
    end

    private

    def transfer_transaction!
      service = TransferService.new(
        sender: current_customer,
        receiver: transaction_create_request.receiver
      )

      service.transfer_amount!(
        amount_cents: transaction_create_request.amount_cents,
        currency: transaction_create_request.currency
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

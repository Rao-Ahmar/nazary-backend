module Api
  module V1
    module Admin
      class PaymentAccountsController < BaseController
        def index
          accounts = PaymentAccount.order(created_at: :desc)
          render json: accounts, each_serializer: PaymentAccountSerializer
        end

        def create
          account = PaymentAccount.new(payment_account_params)

          if account.save
            render json: account, serializer: PaymentAccountSerializer, status: :created
          else
            render json: { error: account.errors.full_messages.join(", ") }, status: :unprocessable_entity
          end
        end

        def update
          account = PaymentAccount.find(params[:id])

          if account.update(payment_account_params)
            render json: account, serializer: PaymentAccountSerializer
          else
            render json: { error: account.errors.full_messages.join(", ") }, status: :unprocessable_entity
          end
        end

        def destroy
          account = PaymentAccount.find(params[:id])
          account.destroy!
          render json: { message: "Payment account deleted" }
        end

        private

        def payment_account_params
          params.permit(:method_type, :account_title, :account_number, :bank_name, :is_active)
        end
      end
    end
  end
end

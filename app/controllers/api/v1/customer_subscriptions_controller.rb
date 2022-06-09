# frozen_string_literal: true

module Api
  module V1
    class CustomerSubscriptionsController < ApplicationController
      def show
        customer_service = CustomerSubscription.find(params[:id])

        render json: CustomerSubscriptionSerializer.render(customer_service),
               status: :ok
      end

      def create
        customer_subscription = CustomerSubscriptionCreationService.new(
          customer_subscription_params: customer_subscription_params,
          billing_params: billing_params
        ).call!

        render json: CustomerSubscriptionSerializer.render(customer_subscription),
               location: api_v1_customer_subscription_path(customer_subscription),
               status: :ok
      end

      private

      def customer_subscription_params
        params.require(:customer_subscription)
              .permit(:customer_id, :subscription_id, customer: %i[first_name last_name street city zip_code])
      end

      def billing_params
        params.require(:billing_details)
              .permit(:card_number, :expiration_month, :expiration_year, :cvv, :zip_code)
      end
    end
  end
end

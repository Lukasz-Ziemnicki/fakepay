# frozen_string_literal: true

module Api
  module V1
    class CustomerSubscriptionsController < ApplicationController
      def show
        customer_subscription = CustomerSubscription.find(params[:id])

        render json: CustomerSubscriptionSerializer.render(customer_subscription),
               status: :ok
      end

      def create
        customer_subscription = Subscriptions::ExistingCustomer::CreateService.new(
          params: customer_subscription_params
        ).call!

        render json: CustomerSubscriptionSerializer.render(customer_subscription),
               location: api_v1_customer_subscription_path(customer_subscription),
               status: :created
      end

      private

      def customer_subscription_params
        params.require(:customer_subscription)
              .permit(:customer_id, :subscription_id)
      end
    end
  end
end

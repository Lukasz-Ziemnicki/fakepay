# frozen_string_literal: true

module Api
  module V1
    class CustomersController < ApplicationController
      def show
        customer = Customer.find(params[:id])

        render json: CustomerSerializer.render(customer),
               status: :ok
      end

      def create
        customer = Subscriptions::NewCustomer::CreateService.new(
          params: customer_params,
          billing_details: billing_params
        ).call!

        render json: CustomerSerializer.render(customer),
               location: api_v1_customer_path(customer),
               status: :created
      end

      private

      def customer_params
        params.require(:customer)
              .permit(:first_name, :last_name, :street, :city, :zip_code,
                      customer_subscriptions_attributes: :subscription_id)
      end

      def billing_params
        params.require(:billing_details)
              .permit(:card_number, :cvv, :expiration_month, :expiration_year, :zip_code)
      end
    end
  end
end

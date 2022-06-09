# frozen_string_literal: true

module ErrorsHandlers
  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound do |exception|
      render json: { errors: { base: [exception.message] } }, status: :not_found
    end

    rescue_from ActiveRecord::RecordInvalid do |exception|
      render json: { errors: exception.record.errors.messages }, status: :unprocessable_entity
    end

    rescue_from Api::Fakepay::ResponseError do |exception|
      render json: { errors: { base: [exception.message] } }, status: :unprocessable_entity
    end
  end
end

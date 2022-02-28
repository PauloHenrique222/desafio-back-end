module Api
  module V1
    class RegistrationsSqsController < ApplicationController
      def create
        result = ReceiveMessages.call(ENV["AWS_REGION"], ENV["AWS_SQS_QUEUE_URL"])

        if result.success?
          render json: result.body, status: :created
        else
          render json: { error: result.error }, status: :unprocessable_entity
        end
      end
    end
  end
end

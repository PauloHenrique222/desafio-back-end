module Api
  module V1
    class RegistrationsController < ApplicationController
      def create
        result = CreateRegistration.call(create_params)

        if result.success?
          render json: result.body, status: :created
        else
          render json: { error: result.error }, status: :unprocessable_entity
        end
      end

      private

      def create_params
        params.require(:account)
              .permit(:name, :phone, :from_partner, :many_partners,
                      entities: %i[name], users: %i[email first_name last_name phone])
      end
    end
  end
end

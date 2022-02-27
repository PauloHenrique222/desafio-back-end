class CreateAccount < ApplicationService
  def initialize(payload, from_fintera: false)
    @payload = payload
    @from_fintera = from_fintera
  end

  def call
    return result_with_error if payload_invalid?

    ActiveRecord::Base.transaction do
      account = Account.create!(account_params)
      CreateEntities.call(@payload[:entities], account)
      Result.new(true, account)
    end
  rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotUnique => e
    result_with_error(e.message)
  end

  def payload_invalid?
    return true if @payload.blank? || @payload[:entities].blank? || users_blank?

    false
  end

  def account_params
    {
      name: @payload[:name],
      phone: @payload[:phone],
      active: @from_fintera,
    }
  end

  def result_with_error(error = "Validation failed: Account is not valid")
    Result.new(false, nil, error)
  end

  def users_blank?
    @payload[:entities].pluck(:users).flatten.blank?
  end
end

class CreateAccount < ApplicationService
  def initialize(payload, from_fintera: false)
    @payload = payload
    @from_fintera = from_fintera
  end

  def call
    return result_with_error if account_invalid?

    ActiveRecord::Base.transaction do
      account = Account.create(account_params)
      CreateEntities.call(@payload[:entities], account)
      CreateUsers.call(@payload[:users], account)
      Result.new(true, account)
    end
  rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotUnique => e
    result_with_error(e)
  end

  def account_invalid?
    return true if @payload.blank?

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
end

class CreateAccount < ApplicationService
  def initialize(payload, from_fintera: false)
    @payload = payload
    @from_fintera = from_fintera
  end

  def call
    return result_with_error unless account_valid?

    account = Account.new(account_params)
    if account.save
      CreateEntities.call(@payload[:entities], account)
      CreateUsers.call(@payload[:users], account)
      Result.new(true, account)
    else
      result_with_error(account.errors.full_messages)
    end
  end

  def account_valid?
    return false if @payload.blank?

    true
  end

  def account_params
    {
      name: @payload[:name],
      active: @from_fintera,
    }
  end

  def result_with_error(error = ["Account is not valid"])
    Result.new(false, nil, error.join(","))
  end
end

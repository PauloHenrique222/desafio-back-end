class CreateAccount < ApplicationService
  def initialize(payload, from_fintera = false)
    @payload = payload
    @from_fintera = from_fintera
  end

  def call
    if account_valid?
      account = Account.new(account_params)
      if account.save && User.insert_all(users_params(account))
        Result.new(true, account)
      else
        result_with_error(account.errors.full_messages)
      end
    else
      result_with_error
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

  def users_params(account)
    @payload[:users].map do |user|
      {
        first_name: user[:first_name],
        last_name: user[:last_name],
        email: user[:email],
        phone: user[:phone].to_s.gsub(/\D/, ""),
        account_id: account.id,
        created_at: Time.zone.now,
        updated_at: Time.zone.now,
      }
    end
  end

  def result_with_error(error = ["Account is not valid"])
    Result.new(false, nil, error.join(","))
  end
end

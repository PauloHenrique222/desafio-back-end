class CreateUsers < ApplicationService
  def initialize(users, account)
    @users = users
    @account = account
  end

  def call
    users_params.map do |user_params|
      user = User.new(user_params)
      user.entity_ids = @account.entity_ids
      user.save
    end
  end

  def users_params
    @users.map do |user|
      {
        first_name: user[:first_name],
        last_name: user[:last_name],
        email: user[:email],
        phone: user[:phone].to_s.gsub(/\D/, ""),
        created_at: Time.zone.now,
        updated_at: Time.zone.now,
      }
    end
  end
end

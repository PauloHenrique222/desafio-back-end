class CreateUsers < ApplicationService
  def initialize(users, account)
    @users = users
    @account = account
  end

  def call
    User.transaction do
      users_instance.each(&:save!)
    rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotUnique
      raise
    end
  end

  def users_instance
    @users.map do |user|
      User.new({ first_name: user[:first_name],
                 last_name: user[:last_name],
                 email: user[:email],
                 phone: user[:phone].to_s.gsub(/\D/, ""),
                 created_at: Time.zone.now,
                 updated_at: Time.zone.now, })
    end
  end
end

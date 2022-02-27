class CreateUsers < ApplicationService
  def initialize(users)
    @users = users
  end

  def call
    User.transaction do
      @users.map do |user|
        User.create(first_name: user[:first_name],
                    last_name: user[:last_name],
                    email: user[:email],
                    phone: user[:phone].to_s.gsub(/\D/, ""))
      end
    rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotUnique
      raise
    end
  end
end

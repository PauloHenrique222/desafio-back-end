class CreateEntities < ApplicationService
  def initialize(entities, account)
    @entities = entities
    @account = account
  end

  def call
    Entity.transaction do
      @entities.each do |entity|
        entity_instance = Entity.new(name: entity[:name], account_id: @account.id)
        entity_instance.user_ids = user_ids(entity[:users])
        entity_instance.save!
      end
    rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotUnique
      raise
    end
  end

  def user_ids(users)
    users_persisted = User.where(email: users.pluck(:email)).to_a
    users.reject! { |user| users_persisted.pluck(:email).include?(user[:email]) }
    users_persisted << CreateUsers.call(users) if users
    users_persisted.flatten.pluck(:id)
  end
end

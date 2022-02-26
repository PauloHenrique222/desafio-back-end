class CreateEntities < ApplicationService
  def initialize(entities, account)
    @entities = entities
    @account = account
  end

  def call
    Entity.insert_all(entities_params)
  end

  def entities_params
    @entities.map do |entity|
      {
        name: entity[:first_name],
        account_id: @account.id,
        created_at: Time.zone.now,
        updated_at: Time.zone.now,
      }
    end
  end
end

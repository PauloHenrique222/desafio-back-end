class CreateEntities < ApplicationService
  def initialize(entities, account)
    @entities = entities
    @account = account
  end

  def call
    Entity.transaction do
      entities_instance.each(&:save!)
    rescue ActiveRecord::RecordInvalid, ActiveRecord::RecordNotUnique
      raise
    end
  end

  def entities_instance
    @entities.map do |entity|
      Entity.new(name: entity[:name], account_id: @account.id)
    end
  end
end

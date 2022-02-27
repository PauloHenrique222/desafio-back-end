class CreateRegistration < ApplicationService
  def initialize(payload)
    @payload = payload
  end

  def call
    result = create_account
    if result.success?
      notify_partners if @payload[:from_partner].eql?(true)
      return Result.new(true, result.body)
    end
    result
  end

  private

  def notify_partners
    NotifyPartner.call
    NotifyPartner.call("another") if @payload[:many_partners].eql?(true)
  end

  def create_account
    CreateAccount.call(@payload, from_fintera: from_fintera?)
  end

  def from_fintera?
    return false unless @payload[:name]&.include?("Fintera")

    @payload[:entities].pluck(:users).flatten.each do |user|
      return true if user[:email].include? "fintera.com.br"
    end

    false
  end
end

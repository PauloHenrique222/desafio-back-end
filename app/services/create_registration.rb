class CreateRegistration < ApplicationService
  def initialize(payload)
    @payload = payload
  end

  def call
    @result = create_account
    notify_partners if @payload[:from_partner].eql?(true) && create_account.success?
    return Result.new(true, @result.body) if @result.success?

    @result
  end

  private

  def notify_partners
    NotifyPartner.call
    NotifyPartner.call("another") if @payload[:many_partners].eql?(true)
  end

  def create_account
    CreateAccount.call(@payload, from_fintera?)
  end

  def from_fintera?
    return false unless @payload[:name]&.include?("Fintera")

    @payload[:users].each do |user|
      return true if user[:email].include? "fintera.com.br"
    end

    false
  end
end

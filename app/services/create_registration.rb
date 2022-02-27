class CreateRegistration < ApplicationService
  def initialize(payload)
    @payload = payload
  end

  def call
    result_account = create_account
    return result_account unless result_account.success?

    if @payload[:from_partner].eql?("true")
      result_notify = notify_partners
      result_account.body[:notify] = result_notify.body
    end
    Result.new(true, result_account.body)
  end

  private

  def notify_partners
    NotifyPartner.call("another") if @payload[:many_partners].eql?("true")
    NotifyPartner.call
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

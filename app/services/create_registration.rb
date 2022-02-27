class CreateRegistration < ApplicationService
  def initialize(payload)
    @payload = payload
  end

  def call
    result = create_account
    return result unless result.success?

    result.body[:notify_partners] = notify_partners if @payload[:from_partner].eql?(true)
    Result.new(true, result.body)
  end

  private

  def notify_partners
    results = []
    results << NotifyPartner.call("another") if @payload[:many_partners].eql?(true)
    results << NotifyPartner.call
    results.map { |result| JSON.parse(result.body) }
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

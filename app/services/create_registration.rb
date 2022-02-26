class CreateRegistration < ApplicationService
  def initialize(payload)
    @payload = payload
  end

  def call
    @result = create_account
    if @payload[:from_partner].eql?(true) && create_account.success?
      @result = notify_partners
    end
    return Result.new(true, @result.body) if @result.success?

    @result
  end

  private

  def notify_partners
    NotifyPartner.new().perform 
    NotifyPartner.new("another").perform if @payload[:many_partners].eql?(true)
  end

  def create_account
    CreateAccount.call(@payload, is_from_fintera?)
  end

  def is_from_fintera?
    return false unless @params[:name].include? "Fintera"

    @params[:users].each do |user|
      return true if user[:email].include? "fintera.com.br"
    end

    false
  end
end

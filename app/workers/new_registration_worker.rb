class NewRegistrationWorker
  include Sidekiq::Worker

  def perform(message_body)
    CreateRegistration.call(message_body[:account])
  end
end

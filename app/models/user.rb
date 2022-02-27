class User < ApplicationRecord
  has_and_belongs_to_many :entities

  after_commit :send_welcome_email

  validates :first_name, presence: true
  validates :last_name, presence: true

  def send_welcome_email
    call_to_action = { label: "Acesse agora", url: "https://fintera.com.br" }
    UserMailer.welcome_email(self, call_to_action).deliver_now
  end
end

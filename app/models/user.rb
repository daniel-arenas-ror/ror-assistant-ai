class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  belongs_to :company

  def name
    email.split("@").first.capitalize
  end

  def self.from_google_one_tap(payload)
    where(provider: 'google_oauth2', uid: payload['sub']).first_or_create do |user|
      user.email = payload['email']
      user.password = Devise.friendly_token[0, 20]
      # user.full_name = payload['name'] # Optional
    end
  end
end

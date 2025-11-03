class Company < ApplicationRecord
  has_many :users, dependent: :destroy
  has_many :quotes, dependent: :destroy
  has_many :real_estates
  has_many :assistants
  has_many :leadCompany
  has_many :leads, through: :leadCompany

  validates :name, presence: true
  validates :name, presence: true
end

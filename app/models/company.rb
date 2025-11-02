class Company < ApplicationRecord
  has_many :users, dependent: :destroy
  has_many :quotes, dependent: :destroy
  has_many :real_estates

  validates :name, presence: true
  validates :name, presence: true
end

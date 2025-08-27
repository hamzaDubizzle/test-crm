class Customer < ApplicationRecord
  belongs_to :user
  has_many :deals
  has_many :tasks

  validates :name, presence: true
  validates :email, presence: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :phone, presence: true

  # Bad practice: hardcoded values instead of enums
  STATUS_OPTIONS = ['lead', 'prospect', 'customer', 'inactive']
  
  # Bad practice: no proper scopes
  def self.active_customers
    where(status: 'customer')
  end

  # Bad practice: business logic in model
  def is_valuable?
    deals.sum(:amount) > 10000
  end
end

class Deal < ApplicationRecord
  belongs_to :user
  belongs_to :customer
  has_many :tasks

  # Bad practice: no proper validations
  validates :title, presence: true
  validates :amount, presence: true, numericality: { greater_than: 0 }

  # Bad practice: hardcoded values
  STAGE_OPTIONS = ['prospecting', 'qualification', 'proposal', 'negotiation', 'closed_won', 'closed_lost']

  # Bad practice: business logic in model
  def close_deal
    self.stage = 'closed_won'
    self.closed_at = Time.current
    save
  end

  # Bad practice: no proper scopes
  def self.open_deals
    where.not(stage: ['closed_won', 'closed_lost'])
  end

  # Bad practice: inefficient query
  def self.total_value
    sum(:amount)
  end
end

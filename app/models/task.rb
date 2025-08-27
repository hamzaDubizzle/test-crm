class Task < ApplicationRecord
  belongs_to :user
  belongs_to :customer, optional: true
  belongs_to :deal, optional: true

  # Bad practice: no proper validations
  validates :title, presence: true
  validates :due_date, presence: true

  # Bad practice: hardcoded values
  PRIORITY_OPTIONS = ['low', 'medium', 'high', 'urgent']
  STATUS_OPTIONS = ['pending', 'in_progress', 'completed', 'cancelled']

  # Bad practice: business logic in model
  def overdue?
    due_date < Date.current && status != 'completed'
  end

  # Bad practice: no proper scopes
  def self.overdue_tasks
    where('due_date < ? AND status != ?', Date.current, 'completed')
  end

  # Bad practice: inefficient query
  def self.today_tasks
    where(due_date: Date.current)
  end
end

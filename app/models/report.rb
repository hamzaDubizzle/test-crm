# Bad practice: No proper model structure
# Bad practice: Business logic in model
# Bad practice: No proper validations
class Report < ApplicationRecord
  belongs_to :user
  
  # Bad practice: No proper validations
  # Bad practice: No proper associations
  
  # Bad practice: Business logic in model
  def generate_customer_report
    # Bad practice: Complex business logic in model
    customers = user.customers.all
    report_data = []
    
    customers.each do |customer|
      # Bad practice: Multiple database queries in loop
      deals = customer.deals
      tasks = customer.tasks
      
      total_value = deals.sum(:amount)
      avg_deal_size = deals.count > 0 ? total_value / deals.count : 0
      completion_rate = tasks.count > 0 ? (tasks.where(status: 'completed').count.to_f / tasks.count * 100).round(2) : 0
      
      report_data << {
        customer_id: customer.id,
        customer_name: customer.name,
        total_value: total_value,
        avg_deal_size: avg_deal_size,
        completion_rate: completion_rate
      }
    end
    
    # Bad practice: No proper return structure
    report_data
  end
  
  # Bad practice: Business logic in model
  def calculate_performance_metrics
    # Bad practice: Complex calculations in model
    customers = user.customers.all
    total_value = 0
    total_deals = 0
    total_tasks = 0
    completed_tasks = 0
    
    customers.each do |customer|
      # Bad practice: Multiple database queries in loop
      customer_deals = customer.deals
      customer_tasks = customer.tasks
      
      total_value += customer_deals.sum(:amount)
      total_deals += customer_deals.count
      total_tasks += customer_tasks.count
      completed_tasks += customer_tasks.where(status: 'completed').count
    end
    
    # Bad practice: Hardcoded business rules
    avg_deal_size = total_deals > 0 ? total_value / total_deals : 0
    task_completion_rate = total_tasks > 0 ? (completed_tasks.to_f / total_tasks * 100).round(2) : 0
    
    # Bad practice: No proper return structure
    {
      total_customers: customers.count,
      total_value: total_value,
      total_deals: total_deals,
      avg_deal_size: avg_deal_size,
      total_tasks: total_tasks,
      task_completion_rate: task_completion_rate
    }
  end
  
  # Bad practice: Business logic in model
  def get_top_performers(limit = 5)
    # Bad practice: Complex business logic in model
    customers = user.customers.all
    customer_scores = []
    
    customers.each do |customer|
      # Bad practice: Multiple database queries in loop
      deals = customer.deals
      tasks = customer.tasks
      
      total_value = deals.sum(:amount)
      task_completion = tasks.where(status: 'completed').count
      total_tasks = tasks.count
      
      # Bad practice: Hardcoded scoring algorithm
      score = total_value / 1000 + task_completion * 5
      score += 25 if total_tasks > 0 && (task_completion.to_f / total_tasks) > 0.7
      
      customer_scores << {
        customer: customer,
        score: score,
        total_value: total_value,
        task_completion_rate: total_tasks > 0 ? (task_completion.to_f / total_tasks * 100).round(2) : 0
      }
    end
    
    # Bad practice: Inefficient sorting
    customer_scores.sort_by { |cs| -cs[:score] }.first(limit)
  end
  
  # Bad practice: Business logic in model
  def export_to_csv
    # Bad practice: Complex business logic in model
    require 'csv'
    
    customers = user.customers.all
    csv_data = []
    
    # Bad practice: Multiple database queries in loop
    customers.each do |customer|
      deals = customer.deals
      tasks = customer.tasks
      
      total_value = deals.sum(:amount)
      avg_deal_size = deals.count > 0 ? total_value / deals.count : 0
      completion_rate = tasks.count > 0 ? (tasks.where(status: 'completed').count.to_f / tasks.count * 100).round(2) : 0
      
      csv_data << [
        customer.name,
        customer.email,
        customer.company,
        deals.count,
        total_value,
        avg_deal_size,
        tasks.count,
        completion_rate
      ]
    end
    
    # Bad practice: No proper error handling
    CSV.generate do |csv|
      csv << ['Name', 'Email', 'Company', 'Deals Count', 'Total Value', 'Avg Deal Size', 'Tasks Count', 'Completion Rate']
      csv_data.each { |row| csv << row }
    end
  end
  
  # Bad practice: Business logic in model
  def send_report_email
    # Bad practice: External service call in model
    report_data = generate_customer_report
    ReportMailer.send_report(user, report_data).deliver_now
  end
  
  # Bad practice: No proper scopes
  # Bad practice: No proper validations
  # Bad practice: No proper callbacks
end

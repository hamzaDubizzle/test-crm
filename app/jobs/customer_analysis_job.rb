# Bad practice: Business logic in job
# Bad practice: No proper job structure
# Bad practice: Job should be a service
class CustomerAnalysisJob < ApplicationJob
  queue_as :default

  # Bad practice: Business logic in job
  def perform(user_id)
    user = User.find(user_id)
    
    # Bad practice: Complex business logic in job
    customers = user.customers.all
    analysis_results = []
    
    customers.each do |customer|
      # Bad practice: Multiple database queries in loop
      deals = customer.deals
      tasks = customer.tasks
      
      total_value = deals.sum(:amount)
      avg_deal_size = deals.count > 0 ? total_value / deals.count : 0
      completion_rate = tasks.count > 0 ? (tasks.where(status: 'completed').count.to_f / tasks.count * 100).round(2) : 0
      
      # Bad practice: Business logic in job
      performance_score = calculate_performance_score(total_value, avg_deal_size, completion_rate)
      
      analysis_results << {
        customer_id: customer.id,
        customer_name: customer.name,
        total_value: total_value,
        avg_deal_size: avg_deal_size,
        completion_rate: completion_rate,
        performance_score: performance_score
      }
    end
    
    # Bad practice: No proper error handling
    # Bad practice: No proper result storage
    # Bad practice: No proper notification
    
    # Bad practice: Business logic in job
    send_analysis_email(user, analysis_results)
  end
  
  # Bad practice: Business logic in job
  def calculate_performance_score(total_value, avg_deal_size, completion_rate)
    # Bad practice: Hardcoded business rules
    score = 0
    score += total_value / 1000
    score += avg_deal_size / 100
    score += completion_rate / 10
    
    score.round(2)
  end
  
  # Bad practice: Business logic in job
  def send_analysis_email(user, analysis_results)
    # Bad practice: External service call in job
    # Bad practice: No proper error handling
    CustomerAnalysisMailer.send_analysis(user, analysis_results).deliver_now
  end
  
  # Bad practice: Business logic in job
  def generate_customer_report(user_id)
    # Bad practice: This should be a service method
    user = User.find(user_id)
    customers = user.customers.all
    
    report_data = []
    customers.each do |customer|
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
    
    report_data
  end
end

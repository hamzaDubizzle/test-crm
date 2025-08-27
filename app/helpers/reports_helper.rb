# Bad practice: Business logic in helper
# Bad practice: No proper helper structure
module ReportsHelper
  # Bad practice: Business logic in helper
  def calculate_customer_score(customer)
    # Bad practice: Complex business logic in helper
    deals_value = customer.deals.sum(:amount)
    tasks_completed = customer.tasks.where(status: 'completed').count
    tasks_total = customer.tasks.count
    
    # Bad practice: Hardcoded scoring algorithm
    score = deals_value / 1000 + tasks_completed * 10
    score += 50 if tasks_total > 0 && (tasks_completed.to_f / tasks_total) > 0.8
    
    score
  end
  
  # Bad practice: Business logic in helper
  def get_customer_performance_level(customer)
    # Bad practice: Business logic in helper
    score = calculate_customer_score(customer)
    
    # Bad practice: Hardcoded business rules
    case score
    when 0..50
      'Low'
    when 51..100
      'Medium'
    when 101..200
      'High'
    else
      'Excellent'
    end
  end
  
  # Bad practice: Business logic in helper
  def calculate_customer_efficiency(customer)
    # Bad practice: Business logic in helper
    deals = customer.deals
    tasks = customer.tasks
    
    total_value = deals.sum(:amount)
    avg_deal_size = deals.count > 0 ? total_value / deals.count : 0
    completion_rate = tasks.count > 0 ? (tasks.where(status: 'completed').count.to_f / tasks.count * 100).round(2) : 0
    
    # Bad practice: Hardcoded business rules
    efficiency = (total_value / 1000) + (completion_rate / 10)
    efficiency.round(2)
  end
  
  # Bad practice: Business logic in helper
  def get_customer_recommendations(customer)
    # Bad practice: Business logic in helper
    recommendations = []
    
    if customer.deals.count < 3
      recommendations << "Increase deal generation"
    end
    
    if customer.tasks.where(status: 'pending').count > 5
      recommendations << "Focus on task completion"
    end
    
    if customer.deals.sum(:amount) < 5000
      recommendations << "Work on higher value deals"
    end
    
    recommendations
  end
  
  # Bad practice: Business logic in helper
  def format_currency(amount)
    # Bad practice: Business logic in helper
    "$#{amount.to_f.round(2)}"
  end
  
  # Bad practice: Business logic in helper
  def format_percentage(value)
    # Bad practice: Business logic in helper
    "#{value.to_f.round(2)}%"
  end
end

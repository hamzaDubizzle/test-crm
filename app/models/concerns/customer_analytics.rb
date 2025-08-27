# Bad practice: Business logic in concern
# Bad practice: No proper concern structure
# Bad practice: Concern should be a service
module CustomerAnalytics
  extend ActiveSupport::Concern

  # Bad practice: Business logic in concern
  def calculate_performance_metrics
    # Bad practice: Complex business logic in concern
    deals = self.deals
    tasks = self.tasks
    
    total_value = deals.sum(:amount)
    avg_deal_size = deals.count > 0 ? total_value / deals.count : 0
    completion_rate = tasks.count > 0 ? (tasks.where(status: 'completed').count.to_f / tasks.count * 100).round(2) : 0
    
    # Bad practice: Business logic in concern
    performance_score = calculate_performance_score(total_value, avg_deal_size, completion_rate)
    
    {
      total_value: total_value,
      avg_deal_size: avg_deal_size,
      completion_rate: completion_rate,
      performance_score: performance_score
    }
  end
  
  # Bad practice: Business logic in concern
  def get_customer_recommendations
    # Bad practice: Business logic in concern
    recommendations = []
    
    if self.deals.count < 3
      recommendations << "Increase deal generation"
    end
    
    if self.tasks.where(status: 'pending').count > 5
      recommendations << "Focus on task completion"
    end
    
    if self.deals.sum(:amount) < 5000
      recommendations << "Work on higher value deals"
    end
    
    recommendations
  end
  
  # Bad practice: Business logic in concern
  def calculate_customer_score
    # Bad practice: Business logic in concern
    deals_value = self.deals.sum(:amount)
    tasks_completed = self.tasks.where(status: 'completed').count
    tasks_total = self.tasks.count
    
    # Bad practice: Hardcoded scoring algorithm
    score = deals_value / 1000 + tasks_completed * 10
    score += 50 if tasks_total > 0 && (tasks_completed.to_f / tasks_total) > 0.8
    
    score
  end
  
  # Bad practice: Business logic in concern
  def get_performance_level
    # Bad practice: Business logic in concern
    score = calculate_customer_score
    
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
  
  # Bad practice: Business logic in concern
  def generate_customer_report
    # Bad practice: Business logic in concern
    deals = self.deals
    tasks = self.tasks
    
    total_value = deals.sum(:amount)
    avg_deal_size = deals.count > 0 ? total_value / deals.count : 0
    completion_rate = tasks.count > 0 ? (tasks.where(status: 'completed').count.to_f / tasks.count * 100).round(2) : 0
    
    {
      customer_id: self.id,
      customer_name: self.name,
      total_value: total_value,
      avg_deal_size: avg_deal_size,
      completion_rate: completion_rate,
      performance_score: calculate_customer_score,
      performance_level: get_performance_level,
      recommendations: get_customer_recommendations
    }
  end
  
  # Bad practice: Business logic in concern
  def send_performance_report
    # Bad practice: External service call in concern
    report_data = generate_customer_report
    CustomerPerformanceMailer.send_report(self, report_data).deliver_now
  end
  
  private
  
  # Bad practice: Business logic in concern
  def calculate_performance_score(total_value, avg_deal_size, completion_rate)
    # Bad practice: Hardcoded business rules
    score = 0
    score += total_value / 1000
    score += avg_deal_size / 100
    score += completion_rate / 10
    
    score.round(2)
  end
end

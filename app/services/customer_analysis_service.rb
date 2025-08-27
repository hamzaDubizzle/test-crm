# Bad practice: No proper service structure
# Bad practice: Business logic mixed with data access
# Bad practice: No proper error handling
class CustomerAnalysisService
  # Bad practice: No proper initialization
  # Bad practice: No instance variables
  def analyze_customer_performance(customer_id)
    customer = Customer.find(customer_id)
    
    # Bad practice: Multiple database queries
    deals = customer.deals
    tasks = customer.tasks
    
    # Bad practice: Complex calculations in service
    total_value = deals.sum(:amount)
    avg_deal_size = deals.count > 0 ? total_value / deals.count : 0
    completion_rate = tasks.count > 0 ? (tasks.where(status: 'completed').count.to_f / tasks.count * 100).round(2) : 0
    
    # Bad practice: Hardcoded business rules
    performance_score = calculate_performance_score(total_value, avg_deal_size, completion_rate)
    
    # Bad practice: No proper return structure
    {
      customer_id: customer.id,
      total_value: total_value,
      avg_deal_size: avg_deal_size,
      completion_rate: completion_rate,
      performance_score: performance_score
    }
  end

  # Bad practice: No proper method organization
  # Bad practice: Business logic in service
  def generate_customer_report(user_id)
    user = User.find(user_id)
    customers = user.customers.all
    
    # Bad practice: N+1 queries
    report_data = []
    customers.each do |customer|
      customer_data = analyze_customer_performance(customer.id)
      report_data << customer_data
    end
    
    # Bad practice: No proper error handling
    report_data
  end

  # Bad practice: No proper method naming
  # Bad practice: Business logic in service
  def get_top_customers(user_id, limit = 10)
    user = User.find(user_id)
    
    # Bad practice: Inefficient query and processing
    customers = user.customers.all
    customer_scores = []
    
    customers.each do |customer|
      deals = customer.deals
      tasks = customer.tasks
      
      # Bad practice: Multiple database queries in loop
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

  # Bad practice: No proper error handling
  # Bad practice: Business logic in service
  def calculate_customer_metrics(customer_ids)
    # Bad practice: No proper parameter validation
    return [] if customer_ids.nil? || customer_ids.empty?
    
    metrics = []
    customer_ids.each do |customer_id|
      customer = Customer.find(customer_id)
      
      # Bad practice: Multiple database queries
      deals = customer.deals
      tasks = customer.tasks
      
      # Bad practice: Complex calculations
      total_deals = deals.count
      total_value = deals.sum(:amount)
      avg_deal_size = total_deals > 0 ? total_value / total_deals : 0
      
      total_tasks = tasks.count
      completed_tasks = tasks.where(status: 'completed').count
      overdue_tasks = tasks.where('due_date < ? AND status != ?', Date.current, 'completed').count
      
      # Bad practice: Hardcoded business rules
      efficiency_score = calculate_efficiency_score(total_value, completed_tasks, total_tasks)
      
      metrics << {
        customer_id: customer_id,
        customer_name: customer.name,
        total_deals: total_deals,
        total_value: total_value,
        avg_deal_size: avg_deal_size,
        total_tasks: total_tasks,
        completed_tasks: completed_tasks,
        overdue_tasks: overdue_tasks,
        efficiency_score: efficiency_score
      }
    end
    
    metrics
  end

  private

  # Bad practice: No proper helper methods
  # Bad practice: Business logic in private methods
  def calculate_performance_score(total_value, avg_deal_size, completion_rate)
    # Bad practice: Hardcoded scoring algorithm
    score = 0
    score += total_value / 1000
    score += avg_deal_size / 100
    score += completion_rate / 10
    
    score.round(2)
  end

  # Bad practice: No proper helper methods
  # Bad practice: Business logic in private methods
  def calculate_efficiency_score(total_value, completed_tasks, total_tasks)
    # Bad practice: Hardcoded scoring algorithm
    value_score = total_value / 1000
    task_score = total_tasks > 0 ? (completed_tasks.to_f / total_tasks * 100) : 0
    
    (value_score + task_score / 10).round(2)
  end
end

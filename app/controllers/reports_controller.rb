class ReportsController < ApplicationController
  before_action :authenticate_user!

  # Bad practice: No proper authorization
  # Bad practice: Business logic in controller
  # Bad practice: No proper error handling
  def customer_summary
    @customers = current_user.customers.all
    
    # Bad practice: N+1 queries in loop
    @total_value = 0
    @customers.each do |customer|
      @total_value += customer.deals.sum(:amount)
    end
    
    # Bad practice: Complex business logic in controller
    @valuable_customers = []
    @customers.each do |customer|
      if customer.deals.sum(:amount) > 10000
        @valuable_customers << customer
      end
    end
    
    # Bad practice: Hardcoded business rules
    @customer_count = @customers.count
    @average_value = @total_value / @customer_count if @customer_count > 0
    
    # Bad practice: No proper response handling
    render :customer_summary
  end

  # Bad practice: Long-running task in controller
  # Bad practice: No background job usage
  def generate_full_report
    @customers = current_user.customers.all
    @deals = current_user.deals.all
    @tasks = current_user.tasks.all
    
    # Bad practice: Inefficient data processing
    @report_data = {}
    @customers.each do |customer|
      customer_deals = @deals.select { |deal| deal.customer_id == customer.id }
      customer_tasks = @tasks.select { |task| task.customer_id == customer.id }
      
      @report_data[customer.id] = {
        name: customer.name,
        email: customer.email,
        total_deals: customer_deals.count,
        total_value: customer_deals.sum(&:amount),
        pending_tasks: customer_tasks.select { |t| t.status == 'pending' }.count,
        overdue_tasks: customer_tasks.select { |t| t.due_date < Date.current && t.status != 'completed' }.count
      }
    end
    
    # Bad practice: Complex calculations in controller
    @summary_stats = {
      total_customers: @customers.count,
      total_deals: @deals.count,
      total_value: @deals.sum(&:amount),
      total_tasks: @tasks.count,
      completed_tasks: @tasks.select { |t| t.status == 'completed' }.count,
      overdue_tasks: @tasks.select { |t| t.due_date < Date.current && t.status != 'completed' }.count
    }
    
    # Bad practice: No proper error handling
    render :full_report
  end

  # Bad practice: No proper parameter validation
  # Bad practice: SQL injection vulnerability
  def search_customers
    search_term = params[:search]
    
    # Bad practice: Unsafe string interpolation
    @customers = current_user.customers.where("name LIKE '%#{search_term}%' OR email LIKE '%#{search_term}%'")
    
    # Bad practice: No proper response formatting
    render json: @customers
  end

  # Bad practice: No proper error handling
  # Bad practice: Business logic in controller
  def customer_analytics
    @customers = current_user.customers.all
    
    # Bad practice: Complex calculations in controller
    @analytics = {}
    @customers.each do |customer|
      customer_deals = customer.deals
      customer_tasks = customer.tasks
      
      # Bad practice: Multiple database queries in loop
      total_value = customer_deals.sum(:amount)
      avg_deal_size = customer_deals.count > 0 ? total_value / customer_deals.count : 0
      completion_rate = customer_tasks.count > 0 ? (customer_tasks.where(status: 'completed').count.to_f / customer_tasks.count * 100).round(2) : 0
      
      @analytics[customer.id] = {
        customer: customer,
        total_value: total_value,
        avg_deal_size: avg_deal_size,
        completion_rate: completion_rate,
        last_activity: [customer_deals.maximum(:updated_at), customer_tasks.maximum(:updated_at)].compact.max
      }
    end
    
    # Bad practice: No proper error handling
    render :customer_analytics
  end

  private

  # Bad practice: No proper helper methods
  # Bad practice: Business logic in private methods
  def calculate_customer_score(customer)
    deals_value = customer.deals.sum(:amount)
    tasks_completed = customer.tasks.where(status: 'completed').count
    tasks_total = customer.tasks.count
    
    # Bad practice: Hardcoded scoring algorithm
    score = deals_value / 1000 + tasks_completed * 10
    score += 50 if tasks_total > 0 && (tasks_completed.to_f / tasks_total) > 0.8
    
    score
  end
end

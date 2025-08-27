# GitHub Copilot Code Review Instructions

## Overview
This document provides comprehensive guidance for GitHub Copilot Code Review when reviewing pull requests in this Ruby on Rails project. Focus on correctness, security, performance, testing, Rails-specific best practices, and proper code organization while maintaining consistency with the project's established patterns.

## What to Ignore
- **Basic linting and formatting issues** - These are handled by RuboCop and other linters
- **Style preferences** - Follow the project's existing style patterns
- **Minor whitespace or indentation** - Unless it affects readability

## Focus Areas

### 1. Correctness & Logic
- **Service Object Patterns**: Services should follow the established pattern:
  - Single responsibility principle
  - Clear `initialize` method with instance variables
  - Public methods for main functionality
  - Private methods for helper logic
  - Return structured data (hashes) rather than raw objects
  - Handle edge cases and nil values appropriately

- **Data Handling**: 
  - Use `deep_dup` for complex object copying
  - Proper use of `index_by` for efficient lookups
  - Consistent hash key usage (symbols preferred)
  - Handle nested data structures safely

### 2. Security
- **Authentication & Authorization**:
  - Verify proper use of `load_and_authorize_resource`
  - Check for proper tenant scoping with `acts_as_tenant`
  - Ensure user permissions are validated before sensitive operations
  - Validate input parameters, especially IDs and user data

- **SQL Injection Prevention**:
  - Use parameterized queries
  - Avoid string interpolation in SQL
  - Use proper ActiveRecord methods instead of raw SQL when possible

- **API Security**:
  - Validate JWT tokens properly
  - Check device authentication where required
  - Ensure proper CORS configuration
  - Validate external API responses

### 3. Performance & Optimization
- **Database Queries**:
  - Use `includes` and `joins` appropriately to avoid N+1 queries
  - Leverage `index_by` for in-memory lookups
  - Use `select` to limit returned fields when appropriate
  - Consider query complexity for large datasets
  - Optimize complex aggregations and calculations
  - Use database indexes effectively

- **Memory Management**:
  - Avoid loading large datasets into memory unnecessarily
  - Use `find_each` for large record sets
  - Consider pagination for large collections
  - Minimize object creation in loops
  - Use `pluck` instead of `map` when only IDs are needed

- **Algorithm Optimization**:
  - Optimize nested loops and iterations
  - Use efficient data structures (hashes for lookups, arrays for ordered data)
  - Consider time complexity for large datasets
  - Cache expensive calculations when appropriate

### 4. Rails Best Practices
- **Model Patterns**:
  - Use proper associations with appropriate options
  - Implement concerns for shared functionality
  - Use scopes for common query patterns
  - Follow the established naming conventions (e.g., `Crm::`, `Lms::`, `Srv::`)

- **Controller Patterns**:
  - Keep controllers thin, delegate business logic to services
  - Use consistent response formatting with `render_success_response`
  - Implement proper error handling with `rescue_from`
  - Use before_action callbacks appropriately

- **Service Object Conventions**:
  - Follow the established service naming pattern (`*Service`)
  - Use instance variables for state management
  - Return structured responses (hashes with success/error indicators)
  - Handle transactions properly for multi-step operations

### 5. Code Organization & Architecture

#### Where Code Should Live - Decision Tree

**Controllers (`app/controllers/`)**
- ✅ **DO**: Handle HTTP requests, parameter validation, authentication, authorization
- ✅ **DO**: Call appropriate services and render responses
- ✅ **DO**: Handle routing and request flow
- ❌ **DON'T**: Put business logic, complex calculations, or data processing
- ❌ **DON'T**: Handle external API calls or file operations

**Models (`app/models/`)**
- ✅ **DO**: Define associations, validations, and basic scopes
- ✅ **DO**: Use concerns for shared behavior across models
- ✅ **DO**: Define basic query methods and scopes
- ❌ **DON'T**: Put business logic, external API calls, or complex calculations
- ❌ **DON'T**: Handle user interface concerns or response formatting

**Services (`app/services/`)**
- ✅ **DO**: Handle business logic and complex operations
- ✅ **DO**: Coordinate between multiple models
- ✅ **DO**: Handle external API integrations
- ✅ **DO**: Process data and perform calculations
- ✅ **DO**: Handle transactions and multi-step operations
- ❌ **DON'T**: Handle HTTP concerns, routing, or view logic

**Jobs (`app/jobs/`)**
- ✅ **DO**: Handle long-running or background tasks
- ✅ **DO**: Process large datasets asynchronously
- ✅ **DO**: Handle external API calls that might timeout
- ✅ **DO**: Send emails, generate reports, or perform cleanup tasks
- ❌ **DON'T**: Handle immediate user requests or real-time operations

**Modules (`app/models/concerns/` or `lib/`)**
- ✅ **DO**: Extract shared behavior across multiple models
- ✅ **DO**: Define utility methods and constants
- ✅ **DO**: Handle cross-cutting concerns (e.g., search, tagging, auditing)
- ❌ **DON'T**: Put model-specific logic or business rules

**Helpers (`app/helpers/`)**
- ✅ **DO**: Handle view-specific logic and formatting
- ✅ **DO**: Extract complex view logic from templates
- ✅ **DO**: Handle presentation concerns (date formatting, number formatting)
- ❌ **DON'T**: Put business logic or data processing

**Concerns (`app/models/concerns/`)**
- ✅ **DO**: Share behavior between models
- ✅ **DO**: Extract common validations, scopes, or callbacks
- ✅ **DO**: Handle cross-cutting model concerns
- ❌ **DON'T**: Put business logic that should be in services

#### Code Organization Examples

**❌ WRONG - Business Logic in Model**
```ruby
# app/models/customer.rb
class Customer < ApplicationRecord
  def calculate_total_value
    deals.sum(:amount) * 1.1 # Business logic in model
  end
  
  def send_welcome_email
    CustomerMailer.welcome(self).deliver_now # External service call in model
  end
end
```

**✅ CORRECT - Business Logic in Service**
```ruby
# app/services/customer_value_service.rb
class CustomerValueService
  def initialize(customer)
    @customer = customer
  end
  
  def calculate_total_value
    @customer.deals.sum(:amount) * 1.1
  end
end

# app/services/customer_notification_service.rb
class CustomerNotificationService
  def initialize(customer)
    @customer = customer
  end
  
  def send_welcome_email
    CustomerMailer.welcome(@customer).deliver_now
  end
end
```

**❌ WRONG - Long-Running Task in Controller**
```ruby
# app/controllers/customers_controller.rb
def generate_report
  @customers = Customer.all
  # This could take minutes and block the user
  @report = generate_complex_report(@customers)
  render :report
end
```

**✅ CORRECT - Long-Running Task in Job**
```ruby
# app/controllers/customers_controller.rb
def generate_report
  GenerateCustomerReportJob.perform_later(current_user.id)
  redirect_to customers_path, notice: 'Report generation started'
end

# app/jobs/generate_customer_report_job.rb
class GenerateCustomerReportJob < ApplicationJob
  def perform(user_id)
    user = User.find(user_id)
    customers = user.customers.all
    report = generate_complex_report(customers)
    # Send report via email or store for later retrieval
  end
end
```

**❌ WRONG - View Logic in Controller**
```ruby
# app/controllers/customers_controller.rb
def show
  @customer = Customer.find(params[:id])
  @formatted_phone = format_phone_number(@customer.phone) # View logic in controller
  @formatted_created_at = @customer.created_at.strftime("%B %d, %Y")
end
```

**✅ CORRECT - View Logic in Helper**
```ruby
# app/helpers/customers_helper.rb
module CustomersHelper
  def format_phone_number(phone)
    # Phone formatting logic
  end
  
  def format_date(date)
    date.strftime("%B %d, %Y")
  end
end

# app/controllers/customers_controller.rb
def show
  @customer = Customer.find(params[:id])
end
```

### 6. Optimization & Performance
- **Algorithm Efficiency**: Ensure algorithms scale appropriately with data size
- **Memory Usage**: Minimize memory allocations and object creation
- **Database Query Optimization**: Optimize complex queries and avoid unnecessary database calls
- **Caching Strategy**: Consider appropriate caching for expensive operations

## Project-Specific Patterns

### Naming Conventions
- **Models**: Use namespaced models (e.g., `Crm::Client`, `Lms::Lead`)
- **Services**: End with `Service` suffix
- **Controllers**: Follow RESTful naming in appropriate namespaces
- **Methods**: Use snake_case consistently

### Data Structure Patterns
- **Response Formatting**: Use consistent hash structures for API responses
- **Metric Handling**: Follow the established pattern for building metric objects with `slug`, `name`, `name_tld`, and `value`
- **Multi-language Support**: Ensure proper handling of `name_tld` fields for Arabic text

### External Service Integration
- **API Calls**: Use `Faraday` for HTTP requests
- **Authentication**: Use environment variables for API tokens
- **Error Handling**: Implement proper error handling for external service failures
- **Response Parsing**: Validate external API responses before processing

### Tenant Architecture
- **Multi-tenancy**: Ensure proper use of `acts_as_tenant` and tenant scoping
- **Environment Variables**: Use tenant-specific environment variables where appropriate
- **Data Isolation**: Verify tenant data isolation in queries and operations

## Review Checklist

### Before Approving
- [ ] Code follows established service object patterns
- [ ] Proper error handling and edge case coverage
- [ ] Security considerations addressed (auth, validation, SQL injection)
- [ ] **Performance optimization implemented** (queries, memory, algorithms)
- [ ] **Code is properly organized** in the correct architectural layer
- [ ] Consistent with project's naming and structure conventions
- [ ] Proper use of ActiveRecord associations and queries
- [ ] External service integration handled safely
- [ ] Multi-tenant considerations addressed
- [ ] **Long-running tasks moved to background jobs**
- [ ] **Business logic extracted to appropriate services**
- [ ] **View logic moved to helpers where appropriate**

### Common Issues to Flag

#### Code Organization Issues
- **Business logic in models** instead of services
- **Long-running tasks in controllers** instead of jobs
- **View logic in controllers** instead of helpers
- **External API calls in models** instead of services
- **Complex calculations in views** instead of helpers or services
- **Missing service objects** for complex business operations
- **Missing background jobs** for time-consuming tasks

#### Performance Issues
- **Missing error handling** for external API calls
- **N+1 query problems** in loops or iterations
- **Performance bottlenecks** in loops, iterations, or data processing
- **Memory inefficiencies** from unnecessary object creation
- **Inefficient algorithms** that don't scale with data size

#### Security Issues
- **Hardcoded values** that should be configurable
- **Missing tenant scoping** in multi-tenant operations
- **Unsafe string interpolation** in database queries
- **Missing authorization checks** for sensitive operations

#### Code Quality Issues
- **Inconsistent response formatting** in APIs
- **Missing proper error handling** for edge cases
- **No proper logging** or monitoring
- **Missing validation** for user inputs

## Code Quality Standards
- **Readability**: Code should be self-documenting with clear method names
- **Maintainability**: Follow DRY principles while avoiding over-abstraction
- **Reliability**: Handle edge cases and provide meaningful error messages
- **Consistency**: Match the existing codebase patterns and conventions
- **Architecture**: Follow proper separation of concerns and Rails architectural patterns

## Decision Making Framework

### When to Use Services
- **Multiple model interactions** required
- **Complex business logic** or calculations
- **External API integrations**
- **Multi-step operations** that need transactions
- **Data processing** and transformations

### When to Use Jobs
- **Long-running operations** (> 5 seconds)
- **External API calls** that might timeout
- **Large dataset processing**
- **Email sending** or notifications
- **File generation** or processing

### When to Use Helpers
- **View-specific formatting** (dates, numbers, text)
- **Complex view logic** that would clutter templates
- **Reusable presentation logic** across multiple views
- **HTML generation** helpers

### When to Use Concerns
- **Shared behavior** across multiple models
- **Common validations** or callbacks
- **Cross-cutting model concerns** (search, tagging, auditing)
- **Reusable model functionality**

### When to Use Modules
- **Utility functions** used across the application
- **Constants** and configuration
- **Shared business logic** that doesn't fit other patterns
- **Third-party integrations** and adapters

## Remember
The goal is to maintain the high quality and consistency of this codebase while ensuring new contributions follow established patterns and best practices. **Always consider where code should live** and ensure proper separation of concerns across the Rails architectural layers.

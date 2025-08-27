# Test CRM Application

This is a small, intentionally poorly structured CRM application built with Ruby on Rails for testing AI-based PR review systems.

## Purpose

This application is designed to demonstrate various anti-patterns and poor coding practices that an AI PR review system should be able to identify and suggest improvements for.

## Features

- User authentication with Devise
- Customer management
- Deal tracking
- Task management
- Basic CRUD operations

## Known Issues (Intentionally Created for Testing)

### Models
- Hardcoded constants instead of proper enums
- Business logic in models
- Inefficient queries
- Missing proper validations
- No proper scopes

### Controllers
- No proper error handling
- No proper parameter filtering
- No proper authorization
- No proper response formatting
- No proper API structure

### Views
- No proper styling
- No proper form validation display
- No proper error handling
- No proper responsive design

### Database
- No proper indexing strategy
- No proper foreign key constraints
- No proper data validation

## Setup

1. Install dependencies:
   ```bash
   bundle install
   ```

2. Configure database in `config/database.yml`

3. Create and setup database:
   ```bash
   rails db:create
   rails db:migrate
   rails db:seed
   ```

4. Start the server:
   ```bash
   rails server
   ```

## Test Account

- Email: test@example.com
- Password: password123

## What AI PR Review Should Catch

1. **Security Issues**: No proper parameter filtering, no authorization
2. **Performance Issues**: N+1 queries, inefficient database queries
3. **Code Quality**: Business logic in models, hardcoded values
4. **Best Practices**: No proper error handling, no proper validation
5. **Rails Conventions**: Missing proper namespacing, no proper routing structure
6. **Database Design**: Missing proper indexes, no proper constraints

## Expected AI PR Review Suggestions

- Add proper authorization with CanCanCan
- Move business logic to services
- Add proper error handling
- Use proper enums instead of constants
- Add proper database indexes
- Implement proper API structure
- Add proper validation and error display
- Follow Rails conventions for routing and namespacing
- Add proper testing
- Implement proper security measures

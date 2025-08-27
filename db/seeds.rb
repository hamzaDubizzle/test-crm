# Bad practice: no proper error handling or data validation
puts "Creating sample data..."

# Create a test user
user = User.create!(
  name: 'Test User',
  email: 'test@example.com',
  password: 'password123',
  password_confirmation: 'password123'
)

# Create sample customers
customer1 = user.customers.create!(
  name: 'John Doe',
  email: 'john@example.com',
  phone: '555-0123',
  company: 'ABC Corp',
  status: 'customer'
)

customer2 = user.customers.create!(
  name: 'Jane Smith',
  email: 'jane@example.com',
  phone: '555-0456',
  company: 'XYZ Inc',
  status: 'prospect'
)

# Create sample deals
deal1 = user.deals.create!(
  title: 'Website Redesign',
  description: 'Complete website overhaul for ABC Corp',
  amount: 25000.00,
  stage: 'proposal',
  customer: customer1
)

deal2 = user.deals.create!(
  title: 'Marketing Campaign',
  description: 'Digital marketing campaign for XYZ Inc',
  amount: 15000.00,
  stage: 'negotiation',
  customer: customer2
)

# Create sample tasks
user.tasks.create!(
  title: 'Follow up with John',
  description: 'Call John about the website proposal',
  due_date: Date.current + 2.days,
  priority: 'high',
  status: 'pending',
  customer: customer1,
  deal: deal1
)

user.tasks.create!(
  title: 'Prepare marketing proposal',
  description: 'Create detailed marketing proposal for Jane',
  due_date: Date.current + 5.days,
  priority: 'medium',
  status: 'pending',
  customer: customer2,
  deal: deal2
)

puts "Sample data created successfully!"
puts "User: test@example.com / password123"

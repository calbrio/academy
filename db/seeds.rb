# This file creates development data for the LMS system
# Run with: rails db:seed

# Clear existing data
puts "Clearing existing data..."
LessonCompletion.destroy_all
CourseEnrollment.destroy_all
Lesson.destroy_all
Course.destroy_all
User.where.not(email: 'admin@example.com').destroy_all

# Create a test user if it doesn't exist
user = User.find_or_create_by!(email: 'student@example.com') do |u|
  u.password = 'password123'
  u.password_confirmation = 'password123'
  puts "Created test user: student@example.com (password: password123)"
end

# Create an admin user if it doesn't exist
admin = User.find_or_create_by!(email: 'admin@example.com') do |u|
  u.password = 'adminpass'
  u.password_confirmation = 'adminpass'
  u.admin = true
  puts "Created admin user: admin@example.com (password: adminpass)"
end

# Create courses
puts "Creating courses and lessons..."

# Web Development Course
web_dev = Course.create!(
  title: "Introduction to Web Development",
  description: "Learn the fundamentals of web development, including HTML, CSS, and JavaScript. This course is designed for beginners who want to start building websites from scratch."
)

# Create lessons for Web Development
web_dev_lessons = [
  { title: "HTML Basics", description: "Learn the building blocks of the web. In this lesson, you'll understand HTML tags, elements, and document structure.", position: 1 },
  { title: "CSS Styling", description: "Make your websites beautiful with CSS. You'll learn about selectors, properties, and responsive design principles.", position: 2 },
  { title: "JavaScript Fundamentals", description: "Add interactivity to your websites with JavaScript. This lesson covers variables, functions, and DOM manipulation.", position: 3 },
  { title: "Building Your First Website", description: "Put it all together by building a complete website from scratch using HTML, CSS, and JavaScript.", position: 4 }
]

web_dev_lessons.each do |lesson_data|
  web_dev.lessons.create!(lesson_data)
end

# Ruby on Rails Course
rails_course = Course.create!(
  title: "Ruby on Rails Masterclass",
  description: "Dive into Ruby on Rails development and learn how to build robust web applications quickly and efficiently. This course covers MVC architecture, ActiveRecord, and deployment."
)

# Create lessons for Rails Course
rails_lessons = [
  { title: "Ruby Language Fundamentals", description: "Learn the basics of Ruby programming language, including syntax, data types, and object-oriented principles.", position: 1 },
  { title: "Rails Framework Overview", description: "Understand the Rails framework, its components, and the concept of convention over configuration.", position: 2 },
  { title: "Models and ActiveRecord", description: "Work with database models using ActiveRecord. Learn about migrations, validations, and associations.", position: 3 },
  { title: "Controllers and Views", description: "Build the user interface of your application with controllers and views. Learn about routing, actions, and ERB templates.", position: 4 },
  { title: "Authentication and Authorization", description: "Implement user authentication and authorization in your Rails applications using Devise and other techniques.", position: 5 },
  { title: "Testing and Deployment", description: "Write tests for your Rails application and learn how to deploy it to production environments.", position: 6 }
]

rails_lessons.each do |lesson_data|
  rails_course.lessons.create!(lesson_data)
end

# Enroll the test user in the Web Development course and complete some lessons
user.enroll_in!(web_dev)
web_dev.lessons.order(:position).limit(2).each do |lesson|
  user.complete_lesson!(lesson)
end

# Enroll the test user in the Rails course but don't complete any lessons yet
user.enroll_in!(rails_course)
user.start_lesson!(rails_course.lessons.order(:position).first)

puts "Seed data created successfully!"
puts "Created 2 courses with a total of #{Lesson.count} lessons"
puts "Test user enrolled in both courses with some lessons completed"

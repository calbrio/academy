class Course < ApplicationRecord
  has_many :lessons, dependent: :destroy
  has_many :course_enrollments, dependent: :destroy
  has_many :enrolled_users, through: :course_enrollments, source: :user
  
  validates :title, presence: true
  
  # Methods for tracking enrollment
  def completion_percentage_for(user)
    return 0 unless user && user.enrolled_in?(self)
    user.course_progress(self)
  end
  
  def total_enrolled_users
    course_enrollments.count
  end
  
  def total_completed_users
    course_enrollments.completed.count
  end
end

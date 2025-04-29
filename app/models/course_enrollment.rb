class CourseEnrollment < ApplicationRecord
  belongs_to :user
  belongs_to :course
  
  # Validations
  validates :user_id, uniqueness: { scope: :course_id, message: "is already enrolled in this course" }
  
  # Scopes
  scope :completed, -> { where.not(completed_at: nil) }
  scope :in_progress, -> { where.not(started_at: nil).where(completed_at: nil) }
  scope :not_started, -> { where(started_at: nil) }
  
  # Methods
  def started?
    started_at.present?
  end
  
  def completed?
    completed_at.present?
  end
  
  def start!
    update(started_at: Time.current) unless started?
  end
  
  def complete!
    update(completed_at: Time.current, progress_percentage: 100) unless completed?
  end
  
  def update_progress!
    total_lessons = course.lessons.count
    return 0 if total_lessons.zero?
    
    completed_lessons = user.lesson_completions
                            .where(lesson: course.lessons, completed: true)
                            .count
    
    percentage = (completed_lessons.to_f / total_lessons * 100).round
    update(progress_percentage: percentage)
    
    # If all lessons are completed, mark the course as completed
    complete! if percentage == 100 && !completed?
    
    percentage
  end
end

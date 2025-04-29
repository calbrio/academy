class LessonCompletion < ApplicationRecord
  belongs_to :user
  belongs_to :lesson
  
  # Validations
  validates :user_id, uniqueness: { scope: :lesson_id, message: "has already started this lesson" }
  
  # Scopes
  scope :completed, -> { where(completed: true) }
  scope :in_progress, -> { where.not(started_at: nil).where(completed: false) }
  
  # Methods
  def started?
    started_at.present?
  end
  
  def completed?
    completed && completed_at.present?
  end
  
  def start!
    update(started_at: Time.current) unless started?
  end
  
  def complete!
    return if completed?
    
    update(completed: true, completed_at: Time.current)
    
    # Update the course enrollment progress
    course_enrollment = user.course_enrollments.find_by(course: lesson.course)
    course_enrollment.update_progress! if course_enrollment
  end
end

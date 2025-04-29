class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
  # Relationships for LMS
  has_many :course_enrollments, dependent: :destroy
  has_many :courses, through: :course_enrollments
  has_many :lesson_completions, dependent: :destroy
  has_many :completed_lessons, -> { where(lesson_completions: { completed: true }) },
           through: :lesson_completions, source: :lesson
           
  # Methods for course enrollment
  def enrolled_in?(course)
    course_enrollments.exists?(course: course)
  end
  
  def enroll_in!(course)
    return if enrolled_in?(course)
    course_enrollments.create(course: course, started_at: Time.current)
  end
  
  def course_progress(course)
    return 0 unless enrolled_in?(course)
    course_enrollments.find_by(course: course).progress_percentage
  end
  
  # Admin methods
  def admin?
    admin
  end
  
  def make_admin!
    update(admin: true)
  end
  
  def revoke_admin!
    update(admin: false)
  end
  
  # Methods for lesson completion
  def started_lesson?(lesson)
    lesson_completions.exists?(lesson: lesson, started_at: ..Time.current)
  end
  
  def completed_lesson?(lesson)
    lesson_completions.exists?(lesson: lesson, completed: true)
  end
  
  def start_lesson!(lesson)
    return if started_lesson?(lesson)
    
    # Ensure user is enrolled in the course
    enroll_in!(lesson.course) unless enrolled_in?(lesson.course)
    
    # Create or update lesson completion record
    completion = lesson_completions.find_or_initialize_by(lesson: lesson)
    completion.start! unless completion.started?
  end
  
  def complete_lesson!(lesson)
    return if completed_lesson?(lesson)
    
    # Ensure user has started the lesson
    start_lesson!(lesson) unless started_lesson?(lesson)
    
    # Mark lesson as completed
    completion = lesson_completions.find_by(lesson: lesson)
    completion.complete! if completion
  end
end

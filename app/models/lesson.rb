class Lesson < ApplicationRecord
  belongs_to :course
  has_many :lesson_completions, dependent: :destroy
  has_many :users_completed, -> { where(lesson_completions: { completed: true }) },
           through: :lesson_completions, source: :user
  
  validates :title, presence: true
  validates :position, presence: true
  
  default_scope { order(position: :asc) }
  
  # Markdown content handling
  def render_markdown
    return '' unless lesson_content
    
    renderer = Redcarpet::Render::HTML.new(
      filter_html: true,
      hard_wrap: true,
      link_attributes: { rel: 'nofollow', target: '_blank' }
    )
    
    markdown = Redcarpet::Markdown.new(renderer, fenced_code_blocks: true)
    markdown.render(lesson_content).html_safe
  end
  
  def has_markdown_content?
    lesson_content.present?
  end
  
  # Methods for tracking completion
  def completion_status_for(user)
    return 'not_started' unless user
    
    completion = user.lesson_completions.find_by(lesson: self)
    
    if completion&.completed?
      'completed'
    elsif completion&.started?
      'in_progress'
    else
      'not_started'
    end
  end
  
  def completion_percentage
    return 0 if course.enrolled_users.empty?
    
    (users_completed.count.to_f / course.enrolled_users.count * 100).round
  end
end

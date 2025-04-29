class LessonCompletionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_lesson
  
  def create
    if params[:status] == 'completed'
      current_user.complete_lesson!(@lesson)
      redirect_to course_lesson_path(@lesson.course, @lesson), notice: "Lesson marked as completed!"
    else
      current_user.start_lesson!(@lesson)
      redirect_to course_lesson_path(@lesson.course, @lesson), notice: "You've started this lesson."
    end
  end
  
  private
  
  def set_lesson
    @lesson = Lesson.find(params[:lesson_id])
  end
end

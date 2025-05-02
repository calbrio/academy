class LessonsController < ApplicationController
  before_action :set_course
  before_action :set_lesson, only: [:show, :edit, :update, :destroy]
  before_action :authenticate_user!, except: [:index]
  before_action :require_admin, only: [:new, :create, :edit, :update, :destroy]

  def index
    @lessons = @course.lessons
  end

  def show
    # Mark the lesson as started and ensure course enrollment is tracked
    if current_user
      current_user.start_lesson!(@lesson) unless current_user.started_lesson?(@lesson)
      
      # Update course progress
      course_enrollment = current_user.course_enrollments.find_by(course: @course)
      course_enrollment.update_progress! if course_enrollment
    end
  end

  def new
    @lesson = @course.lessons.build
  end

  def create
    @lesson = @course.lessons.build(lesson_params)

    if @lesson.save
      redirect_to course_lesson_path(@course, @lesson), notice: 'Lesson was successfully created.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @lesson.update(lesson_params)
      redirect_to course_lesson_path(@course, @lesson), notice: 'Lesson was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @lesson.destroy
    redirect_to course_lessons_path(@course), notice: 'Lesson was successfully destroyed.'
  end

  private

  def set_course
    @course = Course.find(params[:course_id])
  end

  def set_lesson
    @lesson = @course.lessons.find(params[:id])
  end

  def lesson_params
    params.require(:lesson).permit(:title, :description, :position, :lesson_content)
  end
  
  def require_admin
    unless current_user&.admin?
      flash[:alert] = "Only administrators can manage lessons."
      redirect_to course_path(@course)
    end
  end
end

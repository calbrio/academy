class CourseEnrollmentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_course
  
  def create
    if current_user.enrolled_in?(@course)
      redirect_to course_path(@course), notice: "You are already enrolled in this course."
    else
      current_user.enroll_in!(@course)
      redirect_to course_path(@course), notice: "You have successfully enrolled in this course."
    end
  end
  
  private
  
  def set_course
    @course = Course.find(params[:course_id])
  end
end

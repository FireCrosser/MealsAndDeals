class CoursesController < ApplicationController
  def index
    @courses = Course.all
  end

  def new
    @course = Course.new
    #authorize @course
  end

  def create
    @course = Course.new
    @course.attributes = course_params
    @course.course_type_id = 1
    @course.save
    redirect_to root_path
  end

  private
  def course_params
    params.require(:course).permit(:name, :price, :image)
  end
end

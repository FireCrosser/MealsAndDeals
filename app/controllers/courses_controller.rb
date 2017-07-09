class CoursesController < ApplicationController
  def index
    if params.has_key?(:date)
      @course_types_with_courses = CourseType.with_courses_by_date(params[:date])
      render json: @course_types_with_courses, only: [:id, :name],
        include: [courses: { only: [:id, :name, :price, :image, :date] }]
    end
    @course = Course.new
  end
  
  def create
    @course = Course.new
    @course.attributes = course_params
    @course.save
  end

  private
  def course_params
    params.require(:course).permit(:name, :price, :image, :course_type_id)
  end
end

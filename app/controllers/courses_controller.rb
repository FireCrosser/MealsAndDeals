class CoursesController < ApplicationController
  before_action :authenticate_user!

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
    authorize @course
    @course.attributes = course_params
    if @course.save
      render json: { code: 200, message: "Course successfully created! Please, reload to see changes."}
    else
      render json: { code: 400, errors: @course.errors.messages }
    end
  end

  private
  def course_params
    params.require(:course).permit(:name, :price, :image, :course_type_id)
  end
end

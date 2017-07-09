class CourseTypesController < ApplicationController
  def index
    @course_types = CourseType.all
    render json: @course_types, only: [:id, :name]
  end
end

class CourseType < ApplicationRecord
  has_many :courses

  scope :with_courses_by_date, -> (date) { includes(:courses)
    .where(course: { date: date }) }

  #Really tried, but it not working in Arel, only as raw sql
  #scope :with_courses_by_date, -> (date) { 
    #joins("LEFT OUTER JOIN course ON course.course_type_id = "\
          #"course_type.id AND course.date = '#{date}'").distinct }
end

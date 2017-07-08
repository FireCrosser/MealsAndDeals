class CourseType < ApplicationRecord
  has_many :courses

  scope :with_courses, -> { includes(:courses).distinct }
  scope :where_courses_with_date, -> (date) { 
    where(course: { date: [date,  nil] }) }
end

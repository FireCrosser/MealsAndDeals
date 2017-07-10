class Order < ApplicationRecord
  belongs_to :user
  has_many :ordered_courses
  has_many :courses, through: :ordered_courses
  validate :has_exactly_one_course_of_every_type

  scope :by_date, -> (date) { where(created_at:
                                    date.midnight..date.end_of_day) }

  def self.by_date_from_string(date) 
    pdate = Date.parse(date)
    return self.where(created_at: pdate.midnight..pdate.end_of_day)
  end

  private
  def has_exactly_one_course_of_every_type
    course_types = CourseType.all
    logger.info "Courses: #{self.courses.pluck(:course_type_id).to_set.inspect}"
    logger.info "Course types: #{course_types.pluck(:id).to_set.inspect}"
    if (self.courses.collect(&:course_type_id).to_set \
        != course_types.pluck(:id).to_set)
      errors.add(:order, "Order must have one course of every type!") \
    end
  end
end

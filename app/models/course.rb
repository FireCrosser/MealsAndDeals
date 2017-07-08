class Course < ApplicationRecord
  belongs_to :course_type
  has_many :ordered_courses
  has_many :orders, through: :ordered_courses

  validates :name, presence: true
  validates :price, presence: true

  mount_uploader :image, CourseImageUploader

  before_create do
    self.date = Date.today
  end

  scope :by_date, -> (date) { where(date: date) }
end

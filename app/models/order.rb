class Order < ApplicationRecord
  belongs_to :user
  has_many :ordered_courses
  has_many :courses, through: :ordered_courses
end

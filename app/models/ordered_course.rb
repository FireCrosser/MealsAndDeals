class OrderedCourse < ApplicationRecord
  has_many :order
  has_many :course
end

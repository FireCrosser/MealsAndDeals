require 'rails_helper'

describe ::Course, type: :model do

  course = FactoryGirl.create(:course)

  context '#course_date' do

    it 'should have today date' do
      expect(course.date).to eq(Date.today)
    end

  end
end


require 'rails_helper'

RSpec.describe CoursesController, type: :controller do
  describe "GET #index" do
    it "response successfully with 200 code" do
      get :index
      expect(response).to be_success
      #expect(response).to have_http_success(200)
    end

    it "return index template if request without params" do
      get :index
      expect(response).to render_template("index")
    end

    it "return index template if request without params" do
      course = FactoryGirl.create(:course)

      get :index, params: { date: course.date }

      resp = JSON.parse(response.body)
      courses = resp[0]["courses"]
      expect(resp[0]['id'].to_i).to eq(course.course_type_id)
      expect(courses[0]['id'].to_i).to eq(course.id)
      expect(courses[0]['name']).to eq(course.name)
      expect(courses[0]['price'].to_f).to eq(course.price)
    end
  end
end

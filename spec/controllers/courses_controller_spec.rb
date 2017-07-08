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
      expect(resp.first['id'].to_i).to eq(course.id)
      expect(resp.first['name']).to eq(course.name)
      expect(resp.first['price'].to_f).to eq(course.price)
      expect(resp.first['course_type_id'].to_i).to eq(course.course_type_id)
    end
  end
end

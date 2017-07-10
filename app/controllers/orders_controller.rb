class OrdersController < ApplicationController
  before_action :authenticate_user!, except: [:today]
  before_action :authenticate_user_with_auth_token, only: [:today]

  def index
    if params.has_key?(:date)
      @orders = Order.by_date_from_string(params[:date])
      render json: @orders, only: [:id, :created_at],
        include: [courses: { include: :course_type }, user: { only: [:id, :email] }]
    else
      @orders = Order.all
    end

  end

  def today
    @orders = Order.by_date(Date.today)
    render json: @orders
  end

  def create
    order = Order.new
    courses = params[:courses]
    order.user_id = current_user.id
    courses.each { |key, id| order.courses << Course.find_by_id(id) } \
      unless courses == nil
        if order.save
          render json: { code: 200, message: "Order successfully created!"}
        else
          render json: { code: 400, errors: order.errors.messages }
        end
  end

  private

  def authenticate_user_with_auth_token
    authenticate_or_request_with_http_token do |token, options|
      User.find_by(auth_token: token)
    end
  end

end

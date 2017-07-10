class OrdersController < ApplicationController
  before_action :authenticate_user!

  def index
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

end

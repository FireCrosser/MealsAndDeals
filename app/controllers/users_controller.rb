class UsersController < ApplicationController
  before_action :authenticate_user!

  def index
    authorize User
    @users = User.all
  end

  def show
    @user = User.find_by_id(params[:id])
  end
end

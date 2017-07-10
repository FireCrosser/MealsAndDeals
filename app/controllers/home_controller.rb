class HomeController < ApplicationController
  before_action :authenticate_user!, only: [:auth_token]
  def index
  end

  def auth_token
    @auth_token = current_user.auth_token
  end
end

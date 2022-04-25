class ApplicationController < ActionController::Base
  # 全てのcontroller, viewで使える
  before_action :current_user

  private

  def current_user
    return unless session[:user_id]
    @current_user = User.find(session[:user_id])
  end
end

class SessionsController < ApplicationController

  def create
    user = User.find_by(name: params[:session][:name])
    if user && user.authenticate(params[:session][:password])
      session[:user_id] = user.id
      redirect_to user_path(user.id), flash: { notice: "#{params[:session][:name]}さんようこそ" }
    else
      redirect_to root_path, flash: { error: "ログインに失敗しました" }
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to boards_path
  end
end

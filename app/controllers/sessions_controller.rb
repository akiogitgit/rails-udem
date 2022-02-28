class SessionsController < ApplicationController
  # ログイン成功時にsessionにuser_idを保存
  def create
    # User のname, passwordが合ってたら
    user = User.find(name: params[:session][:name]) # userを探す

    if user && user.authenticate(params[:sessoin][:password]) # userがいて、pwdあってる？
      session[:user_id] = user.id # セッションに保存 user_id はなんでもいい
      redirect_to mypage_path, flash: { notice: "ログインしました" }
    else
      redirect_to root_path, flash: { error: "ログインに失敗しました" }
    end
  end

  def destroy
    # reset_session # 全てのsession を消す
    session[:user_id] = nil

    redirect_to boards_path
  end
end

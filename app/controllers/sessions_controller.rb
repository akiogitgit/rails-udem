class SessionsController < ApplicationController
  # ログイン成功時にsessionにuser_idを保存
  def create
    # User のname, passwordが合ってたら
    session[:user_id] = user.id # セッションに保存 user_id はなんでもいい
  end

  def destroy
    # session[:user_id].clear
    # reset_session # 全てのsession を消す
    session[:user_id] = nil
  end
end

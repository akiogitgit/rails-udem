class SessionsController < ApplicationController
  # ログイン成功時にsessionにuser_idを保存
  def create
    # User のname, passwordが合ってたら
    user = User.find_by(name: params[:session][:name]) # userを探す
    # authenは has_secure_password を追加すると使えるメソッド
    if user && user.authenticate(params[:session][:password])  # userがいて、pwdあってる？
      session[:user_id] = user.id # セッションに保存 user_id はなんでもいい
      redirect_to mypage_path, flash: { notice: "#{params[:session][:name]}さんようこそ" }
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

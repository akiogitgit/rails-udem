class ApplicationController < ActionController::Base
  # このファイル内に書くと、全てのcontrollerで使える
  before_action :current_user # 全てのアクションの先頭に

  private

  def current_user
    return unless session[:user_id] # sessioinがないとき、nilで終了
    @current_user = User.find_by(id: session[:user_id]) # 今ログインしているuserデータ
  end
end

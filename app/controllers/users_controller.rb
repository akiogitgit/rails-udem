class UsersController < ApplicationController
  def new
    @user = User.new(flash[:user]) # ミスっても消えない
  end

  def create
    user = User.new(user_params)
    if user.save
      session[:user_id] = user.id # セッションに保存 user_id はなんでもいい
      # session[:anpan] = user.id
      redirect_to mypage_path, flash: { notice: "ユーザーを登録しました" }
    else
      redirect_to new_user_path, flash: {
        user: user,
        error: user.errors.full_messages
      }
    end
  end

  def me
    @current_user = User.find(session[:user_id]) if session[:user_id].present?
    @users = User.all
    @boards = Board.where(name: @current_user.name)
  end

  private

  def user_params
    params.require(:user).permit(:name, :password, :password_confirmation)
  end


end

class UsersController < ApplicationController

  def index
    @users = User.all
  end

  # user個別ページ
  def show
    session[:user] = nil
    @user = User.find(params[:id])
    if @user == current_user
      @boards = Board.where(name: @user.name).order(id: "DESC")
    else
      @boards = Board.where(name: @user.name).where(published: true).order(id: "DESC")
    end
    # flash[:follow_user_name] = @user.name # user_relationのフォローで使う
    session[:user] = @user # ユーザーのフォロー、フォロワー一覧で使う
  end
  
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
    session[:user] = nil
    # ログインしているユーザーのみ表示
    if @current_user.present?
        # @current_user = User.find(session[:user_id]) if session[:user_id].present?
        @boards = Board.where(name: @current_user.name).order(id: "DESC")
    else
      redirect_to root_path, flash: { error: "ログインしてください" }
    end
    session[:user] = @user # ユーザーのフォロワー、フォロー一覧で使う
  end

  private

  def user_params
    params.require(:user).permit(:name, :password, :password_confirmation)
  end
end

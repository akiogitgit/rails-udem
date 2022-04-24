class UsersController < ApplicationController
  before_action :set_user, only: %i[show edit update destroy]
  before_action :check_current_user, only: %i[edit update]

  def index
    @q = User.all.ransack(params[:q])
    @users = @q.result(distinct: true)
    session[:user_name] = nil
  end
  
  # user個別ページ
  def show
    session[:user] = nil
    session[:user_name] = nil
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
      redirect_to user_path(user.id), flash: { notice: "ユーザーを登録しました" }
    else
      redirect_to new_user_path, flash: {
        user: user,
        error: user.errors.full_messages
      }
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to @user
    else
      redirect_to request.referer#, flash: { error: @user.errors.full_messeges }
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :password, :password_confirmation, :image)
    end

    def set_user
      @user = User.find(params[:id])
    end

    def check_current_user
      redirect_to boards_path, flash: { error: "そのユーザーは編集出来ません。" } if @user != current_user
    end
end

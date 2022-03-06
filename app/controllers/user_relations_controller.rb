class UserRelationsController < ApplicationController

  # boardからフォローするなら、board.id 160で、board = Board.find(params[:id])
  # それでboardから名前出してフォローする

  # ユーザー個別ページからフォローする場合もある？
  def create
    # params[:id]が切れて使えない flashか？
    board = Board.find(flash[:board_id]) # board.idからboard情報
    # board = Board.find(params[:id])
    user = User.find_by(name: board.name) # board.nameからuser情報
    if @current_user.follow(user.id)
      flash[:notice] = "フォローしました#{params[:id]}"
      # flash[:notice] = "#{params[:id]}"
      redirect_to request.referer
    else
      flash[:error] = "フォローに失敗しました"
    end
  end

  def destroy
    @current_user.unfollow(params[:user_id])
    redirect_to request.referer
  end

  # folllowings, followersはparams[:id]使えない。session,flash使う？
  # sessionだと、消すタイミング難しそう。。。
  # フォロー一覧
  def followings
    # if params[:id].present?
    if session[:user].present?
      # user = User.find(params[:id]) # 表示しているユーザーの
      @user = User.find(session[:user]["id"])
    else
      @user = User.find(@current_user.id) # loginユーザーのフォロー一覧
    end
    @users = @user.followings
  end

  # フォロワー一覧
  def followers
    # if params[:id].present?
    if session[:user].present?
      # user = User.find(params[:id])
      @user = User.find(session[:user]["id"])
    else
      @user = User.find(@current_user.id) # loginユーザーのフォロー一覧
    end
    @users = @user.followers
  end

  private

  def follow_params
    # 受け取るのは commentテーブルの このカラム
    params.require(:follow).permit(:followed_id, :follower_id)
  end
end

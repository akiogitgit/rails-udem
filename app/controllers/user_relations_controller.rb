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

  
  # 自分のフォローか、全員のか
  # フォロー一覧
  def followings
    # 表示しているユーザーの
    # 今ログインしているユーザーのフォロー一覧
    # user = User.find(params[:user_id])
    user = User.find(@current_user.id)
    @users = user.followings
  end

  # フォロワー一覧
  def followers
    # user = User.find(params[:user_id])
    user = User.find(@current_user.id)
    @users = user.followers
  end

  private

  def follow_params
    # 受け取るのは commentテーブルの このカラム
    params.require(:follow).permit(:followed_id, :follower_id)
  end
end

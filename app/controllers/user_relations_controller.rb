class UserRelationsController < ApplicationController

  def create
    # @current_user.follow(params[:user_id])
    # follow = UserRelation.new(follow_params)
    # if follow.save
    if @current_user.follow(params[:user_id])
      flash[:notice] = "フォローしました"
      redirect_to request.referer
    else
      flash[:error] = "フォローに失敗しました"
    end
  end

  def destroy
    @current_user.unfollow(params[:user_id])
    redirect_to request.referer
  end
  
  # フォロー一覧
  def followings
    # 表示しているユーザーの
    # 今ログインしているユーザーのフォロー一覧
    # user = User.find(params[:user_id])
    user = User.find(@current_user.id)
    @users = user.followings if user.followings.present?
  end

  # フォロワー一覧
  def followers
    user = User.find(params[:user_id])
    @users = user.followers
  end

  private

  def follow_params
    # 受け取るのは commentテーブルの このカラム
    params.require(:follow).permit(:followed_id, :follower_id)
  end
end

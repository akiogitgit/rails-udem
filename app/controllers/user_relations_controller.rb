class UserRelationsController < ApplicationController

  def create
    if flash[:follow_user_name]
      user = User.find_by(name: flash[:follow_user_name]) # board/show から押した時
    else
      user = User.find(params[:format]) # users/index show から
    end

    if @current_user.follow(user.id)
      flash[:notice] = "#{user.name}さんをフォローしました"
      redirect_to request.referer
    else
      flash[:error] = "フォローに失敗しました"
    end
  end

  def destroy
    if flash[:follow_user_name]
      user = User.find_by(name: flash[:follow_user_name]) # boards/show, users/showから
    else
      user = User.find(params[:id]) # users/index show から
    end
    
    if @current_user.unfollow(user.id) # model/user
      flash[:error] = "#{user.name}さんのフォローを解除しました"
      redirect_to request.referer
    else
      flash[:error] = "フォロー解除に失敗しました"
    end
  end

  # フォローユーザー一覧
  def followings
    if params[:format].present?
      @user = User.find(params[:format])
    end
    @users = @user.followings
  end

  # フォロワーユーザー一覧
  def followers
    if params[:format].present?
      @user = User.find(params[:format])
    end
    @users = @user.followers
  end

  private

  def follow_params
    params.require(:follow).permit(:followed_id, :follower_id)
  end
end

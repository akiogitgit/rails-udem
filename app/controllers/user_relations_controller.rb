class UserRelationsController < ApplicationController
  # boardからフォローするなら、board.id 160で、board = Board.find(params[:id])
  # それでboardから名前出してフォローする

  # フォローする場合
  # users/show, users/index, boards/show -> params[:id] = board.idだからflash
  def create
    # board/showからはflashで、usersからはparams
    user = flash[:follow_user_name] ? User.find_by(name: flash[:follow_user_name]) : User.find(params[:format])
    if @current_user.follow(user.id)
      redirect_to request.referer, flash: { notice: "#{user.name}さんをフォローしました"}
    else
      flash[:error] = "フォローに失敗しました"
    end
  end

  def destroy
    user = flash[:follow_user_name] ? User.find_by(name: flash[:follow_user_name]) : User.find(params[:id])
    if @current_user.unfollow(user.id) # model/user
      redirect_to request.referer, flash: { notice: "#{user.name}さんのフォローを解除しました"}
    else
      flash[:error] = "フォロー解除に失敗しました"
    end
  end

  # folllowings, followersはparams[:id]使えない。session,flash使う？
  # sessionだと、消すタイミング難しそう。。。
  # followings_path(@user.id)で、params[:format]として受け取れる！
  # フォロー一覧
  def followings
    if params[:format].present?
      @user = User.find(params[:format])
    end
    @users = @user.followings
  end

  # フォロワー一覧
  def followers
    if params[:format].present?
      @user = User.find(params[:format])
    end
    @users = @user.followers
  end

  private

  def follow_params
    # 受け取るのは commentテーブルの このカラム
    params.require(:follow).permit(:followed_id, :follower_id)
  end
end

class CommentsController < ApplicationController
  def create
    # ログインしていないユーザーは、登録してる名前を使えない
    if User.find_by(name: params[:comment][:name]) && @current_user.nil?
      flash[:error] = "その名前は使用できません"
      redirect_to request.referer
    else
      # こっちはCommentの方のcomment
      comment = Comment.new(comment_params)
      if comment.save
        redirect_to comment.board, flash:{ notice: "コメントを投稿しました" }
      else
        # validate error
        flash[:comment] = comment
        flash[:error] = comment.errors.full_messages
        redirect_back fallback_location: comment.board
      end
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    if @current_user.present? && @comment.name == @current_user.name
      @comment.destroy
      redirect_to request.referer, flash:{ error: "コメントを削除しました。" }
    else
      redirect_to request.referer, flash:{ error: "このコメントは削除できません" }
    end
  end

  private

  def comment_params
    # 受け取るのは commentテーブルの このカラム
    params.require(:comment).permit(:board_id, :name, :comment)
  end
end

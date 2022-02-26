class CommentsController < ApplicationController
  def create
    # こっちはCommentの方のcomment
    comment = Comment.new(comment_params)
    if comment.save
      redirect_to comment.board, flash:{
        notice: "コメントを投稿しました"
      }
    else
      # validate error
      flash[:comment] = comment
      flash[:error] = comment.errors.full_messages
      redirect_back fallback_location: comment.board
    end
    # binding.pry
  end

  def destroy
    @comment = Comment.find(params[:id])
    @comment.destroy
    redirect_to boards_path, flash: {
      error: "コメントを削除しました。"
    }
  end

  private

  def comment_params
    # 受け取るのは commentテーブルの このカラム
    params.require(:comment).permit(:board_id, :name, :comment)
  end
end

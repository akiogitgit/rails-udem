class CommentsController < ApplicationController
  def create
    comment = Comment.new(comment_params)
    if comment.save
      redirect_to root_path, flash:{
        notice: "コメントを投稿しました"
      }
    else
      redirect_to board_path
    end
    # binding.pry
  end

  def destroy
  end

  private

  def comment_params
    # 受け取るのは commentテーブルの このカラム
    params.require(:comment).permit(:board_id, :name, :comment)
  end
end

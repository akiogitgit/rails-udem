class TagsController < ApplicationController
  before_action :set_tag, only: %i[destroy]
  def index
    @tags = Tag.all
    @tag = Tag.new
  end

  def create
    @tag = Tag.new
    tag = Tag.new(tag_params)
    if tag.save
      redirect_to tags_path,flash:{ notice: "タグを作成しました。" }
    else
      redirect_to tags_path,flash:{ notice: "タグの作成に失敗しました。" }
    end
  end

  def destroy
    if @tag.destroy
      redirect_to tags_path,flash:{ error: "タグを削除しました。" }
    else
      redirect_to tags_path,flash:{ error: "タグの削除に失敗しました" }
    end
  end

  private

  def tag_params
    params.require(:tag).permit(:name)
  end

  def set_tag
    @tag = Tag.find(params[:id])
  end
end

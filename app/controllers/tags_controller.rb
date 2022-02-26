class TagsController < ApplicationController
  before_action :set_tag, only: %i[destroy]
  def index
    @tags = Tag.all
  end

  def create
    @tag = Tag.new
    tag = Tag.new(tag_params)
    if tag.save
      redirect_to board_path,flash:{ notice: "タグを作成" }
    else
      redirect_to tags_path,flash:{ notice: "タグの作成失敗" }
    end
  end

  def destroy
    if @tag.destroy
      redirect_to board_path,flash:{ notice: "タグを削除" }
    else
      redirect_to tags_path,flash:{ error: "タグの削除失敗" }
    end
  end

  private

  def tag_params
    params.require(:tag).permit(:name)
  end

  def set_tag
    @tag = Tag.new(params:[:tags])
  end
end

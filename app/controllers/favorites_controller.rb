class FavoritesController < ApplicationController
  def create
    Favorite.create(user_id: @current_user.id, board_id: params[:board_id])#board.id)
    redirect_to request.referer
  end

  def destroy
    Favorite.find_by(user_id: @current_user.id, board_id: params[:board_id]).delete
    redirect_to request.referer
  end
end

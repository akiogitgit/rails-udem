class BoardsController < ApplicationController
  helper_method :sort_column, :sort_direction
  before_action :set_board, only: %i[show edit update destroy]

  def index
    # タグの選択
    session[:tag_id] = nil if params[:all].present? # タグで絞り込むで全表示は諦めて、全表示ボタンを作成
    session[:tag_id] = params[:tag_id] if params[:tag_id].present? && session[:tag_id] != params[:tag_id] # paramsが来て、sessionと違うならsessionを更新

    if session[:tag_id].present?
      @q = Tag.find(session[:tag_id]).boards.where(published: true).page(params[:page]).order("#{sort_column} #{sort_direction}").ransack(params[:q])
      @boards = @q.result(distinct: true)
    else
      @q = Board.page(params[:page]).where(published: true).order("#{sort_column} #{sort_direction}").ransack(params[:q])  # タグ検索追加(タグで絞りこむで全表示)
      @boards = @q.result(distinct: true)
    end
  end

  def new
    @board = Board.new(flash[:board]) # createに失敗した時、入力データを保持
  end

  def create
    # ログインしていないユーザーは、登録してる名前を使えない
    if User.find_by(name: params[:board][:name]) && @current_user.nil?
      redirect_to new_board_path, flash: {
        board: board_params, # newに渡す
        error: "そのユーザーは既に存在します"
      }
    else
      board =  Board.new(board_params)
      # 成功
      if board.save
        flash[:notice] = "「#{params[:board][:title]}」の掲示板を作成しました。"
        redirect_to boards_path
      else 
        redirect_to new_board_path, flash: {
          board: board,
          error: board.errors.full_messages
        }
      end
    end
  end
  
  def show
    # @comment = @board.comments.new # これはboardの方のcomment。知らぬ間にsaveされるから、空のまま使われる。よくないから消す
    @comment = Comment.new(board_id: @board.id)
    @user = User.find_by(name: @board.name)
    flash[:follow_user_name] = @board.name
    session[:board_title] = nil
    session[:board_id] = nil
  end

  def edit
    if @current_user.nil? || @board.name != @current_user.name
      flash[:error] = "この投稿は編集できません"
      redirect_to boards_path
    end
  end

  # 普通にboardを更新する or いいね
  def update
    if @board.update(board_params)
      flash[:notice] = "「#{@board.title}」 の掲示板を更新しました。"
      redirect_to boards_path
    else
      flash[:board] = board_params
      flash[:error] = @board.errors.full_messages
      redirect_back(fallback_location: boards_path)
    end
  end
  
  def destroy
    if @current_user.present? && @board.name == @current_user.name
      @board.destroy # deleteでもいける
      redirect_to boards_path, flash: { error: "「#{@board.title}」 の掲示板を削除しました。" }
    else
      flash[:error] = "この投稿は削除できません"
      redirect_to request.referer
    end
  end

  private
  
  def board_params
    params.require(:board).permit(:name, :title, :body, :published, tag_ids: [])
  end

  def set_board
    @board = Board.find(params[:id])
  end

  # paramsに asc・descが無いなら、ascを返す
  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : 'desc'
  end
  
  # Boardのカラムに含まれていないなら、初期値でidでソート
  def sort_column  
    Board.column_names.include?(params[:column]) ? params[:column] : 'id'
  end
end


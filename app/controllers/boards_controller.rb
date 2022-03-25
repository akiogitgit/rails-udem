class BoardsController < ApplicationController
  helper_method :sort_column, :sort_direction
  # 最初に指定したメソッドで実行(このメソッドの中に@boardの文が入る)
  before_action :set_board, only: %i[show edit update destroy]

  # tag > kaminari > order, 全表示
  def index
    session[:tag_id] = nil if params[:all].present? # タグで絞り込むで全表示は諦めて、全表示ボタンを作成
    session[:tag_id] = params[:tag_id] if params[:tag_id].present? && session[:tag_id] != params[:tag_id] # paramsが来て、sessionと違うならsessionを更新
    @boards = session[:tag_id].present? ? Tag.find(session[:tag_id]).boards.page(params[:page]).where(published: true).order("#{sort_column} #{sort_direction}") : Board.page(params[:page]).where(published: true).order("#{sort_column} #{sort_direction}")  # タグ検索追加(タグで絞りこむで全表示)
  end

  # 新規作成 new(get), create(post)
  def new
    # @board = Board.new
    @board = Board.new(flash[:board]) # createに失敗した時、入力データはそのままにする
  end

  # newで登録したやつを、POSTで受け取って作成 paramsにPOSTで送信されたデータが保存される params[:board]に必要なやつが入っている
  # flashのnoticeというキーに値を格納
  def create
    # ログインしていないユーザーは、登録してる名前を使えない
    if User.find_by(name: params[:board][:name]) && @current_user.nil?
      redirect_to new_board_path, flash: {
        board: board_params,
        error: "その名前は使用できません" # そのユーザーは既に存在します
      }
    else
      board =  Board.new(board_params)
      if board.save # validationチェック
        flash[:notice] = "「#{params[:board][:title]}」の掲示板を作成しました。"
        redirect_to boards_path
      else 
        # flashで、newに入力データを渡す
        redirect_to new_board_path, flash: {
          board: board,
          error: board.errors.full_messages
        }
      end
    end
  end

  # 動的(get) 個別ページ
  def show
    # @board = Board.find(params[:id])
    # @comment = @board.comments.new # これはboardの方のcomment。知らぬ間にsaveされるから、空のまま使われる。よくないから消す
    @comment = Comment.new(board_id: @board.id)
    @user = User.find_by(name: @board.name)
    flash[:follow_user_name] = @board.name
  end

  # 編集edit(get), update(post)
  def edit # @boardを受け取っている
    if @current_user.present? && @board.name == @current_user.name
      # @board = Board.find(params[:id])
      # もしvalidateに引っかかったら、内容を受け渡す
      if flash[:error]
        @board2 = flash[:board]
        # binding.pry
      end
    else
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
      # redirect_to edit
    end
  end
  
  def destroy
    if @current_user.present? && @board.name == @current_user.name
      @board.destroy # deleteでもいける
      # flash[:error] = "「#{@board.title}」 の掲示板を削除しました。" # redirectにくっつける書き方もある
      redirect_to boards_path, flash: { error: "「#{@board.title}」 の掲示板を削除しました。" }
    else
      flash[:error] = "この投稿は削除できません"
      redirect_to request.referer
    end
  end

  private # これより下に、普通のは置かない
  
  # 必要ないのを受け取らないように、strong parameterで制限する
  def board_params
    params.require(:board).permit(:name, :title, :body, :published, tag_ids: []) # tag_idsはタグ
  end

  def set_board
    # before_actionで指定したアクションの一番上で実行されるから、消す
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
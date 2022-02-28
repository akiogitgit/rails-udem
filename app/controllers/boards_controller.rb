class BoardsController < ApplicationController

  # 最初に指定したメソッドで実行(このメソッドの中に@boardの文が入る)
  before_action :set_board, only: %i[show edit update destroy]

  def index
    # @board = Board.all
    # @boards = Board.page(params[:page]) # kaminariのページメソッド(25件)
    # @boards = Tag.find(params[:tag_id]).boards.page(params[:page]) if params[:tag_id] >= "1" # kaminariも適応される
    @boards = params[:tag_id].present? ? Tag.find(params[:tag_id]).boards.page(params[:page]) : Board.page(params[:page])  # kaminariも適応される

    # Tagの方から探して、Tagに関連付くboardを取得
    # Tag.find(1).boards.title
  end

  # 新規作成 new(get), create(post)
  def new
    # @board = Board.new
    @board = Board.new(flash[:board]) # createに失敗した時、入力データはそのままにする
    @current_user = User.find(session[:user_id]) if session[:user_id].present?

  end
  
  # newで登録したやつを、POSTで受け取って作成 paramsにPOSTで送信されたデータが保存される params[:board]に必要なやつが入っている
  # flashのnoticeというキーに値を格納
  def create
    # Board.create(board_params) # validateやらないなら、createでOK
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

  # 動的(get) 個別ページ
  def show
    # commentをここで使う
    @comment = Comment.new(board_id: @board.id)
    # @comment = @board.comments.new # これはboardの方のcomment。知らぬ間にsaveされるから、空のまま使われる
    # binding.pry
  end

  # 編集edit(get), update(post)
  def edit # @boardを受け取っている
    # @board = Board.find(params[:id])
    if flash[:error]
      @board2 = flash[:board]
      # binding.pry
    end
  end

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
    @board.destroy # deleteでもいける
    # flash[:error] = "「#{@board.title}」 の掲示板を削除しました。" # redirectにくっつける書き方もある
    redirect_to boards_path, flash: { error: "「#{@board.title}」 の掲示板を削除しました。" }
  end

  private # これより下に、普通のは置かない
  
  # 必要ないのを受け取らないように、strong parameterで制限する
  def board_params
    params.require(:board).permit(:name, :title, :body, tag_ids: []) # tag_idsはタグ
  end

  def set_board
    # show create edit update destroyの一番上で実行されるから、消す
    @board = Board.find(params[:id])
  end
end


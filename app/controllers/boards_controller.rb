class BoardsController < ApplicationController

  # 最初に指定したメソッドで実行(このメソッドの中に@boardの文が入る)
  before_action :set_board, only: %i[show edit update destroy]

  def index
    # @board = Board.all # 最初(全部表示)
    # @boards = Board.page(params[:page]) # kaminariのページメソッド(25件)
    # @boards = params[:tag_id].present? ? Tag.find(params[:tag_id]).boards.page(params[:page]).order(id: "DESC") : Board.page(params[:page]).order(id: "DESC")  # タグ検索追加(タグで絞りこむで全表示)

    # tagは初期値nil,paramsが来たらsessionを変更,
    # tag_id="" (タグで絞り込む)ならsession = nil
    # asc変更したら、tag_idが来なくなる
    if session[:order_by].nil?
      session[:order_by] = "0"
    end
    # タグで絞り込むで全表示は諦めて、全表示ボタンを作成
    if params[:all].present?
      session[:tag_id] = nil
    end
    # sessionとparamsが違ったらsessionを更新
    if params[:order_by].present?
      if session[:order_by] != params[:order_by][:asc]
        session[:order_by] = params[:order_by][:asc]
      end
    end
    # paramsが来て、sessionと違うならsessionを更新
    if params[:tag_id].present?
      if session[:tag_id] != params[:tag_id]
        session[:tag_id] = params[:tag_id]
      end
    end
    # paramsない時sessionのでやる
    if session[:order_by] == "1"
      # binding.pry
      @boards = session[:tag_id].present? ? Tag.find(session[:tag_id]).boards.page(params[:page]).order(id: "ASC") : Board.page(params[:page]).order(id: "ASC")  # タグ検索追加(タグで絞りこむで全表示)
      @asc = "1"
      flash[:asc] = 1
    else
      @boards = session[:tag_id].present? ? Tag.find(session[:tag_id]).boards.page(params[:page]).order(id: "DESC") : Board.page(params[:page]).order(id: "DESC")
      @asc = "0"
      flash[:asc] = nil
    end
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
  end

  # 動的(get) 個別ページ
  def show
    # @board = Board.find(params[:id])
    # commentをここで使う
    # @comment = @board.comments.new # これはboardの方のcomment。知らぬ間にsaveされるから、空のまま使われる。よくないから消す
    @comment = Comment.new(board_id: @board.id)
    @user = User.find_by(name: @board.name)
    flash[:follow_user_name] = @board.name
    # これ違う
    # if @user.present?
    #   @follow = UserRelation.new(follower_id: @current_user.id)
    # end
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
    params.require(:board).permit(:name, :title, :body, tag_ids: []) # tag_idsはタグ
  end

  def set_board
    # show create edit update destroyの一番上で実行されるから、消す
    @board = Board.find(params[:id])
  end
end


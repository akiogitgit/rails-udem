class BoardsController < ApplicationController

    # 最初に指定したメソッドで実行(このメソッドの中に@boardの文が入る)
    before_action :set_board, only: %i[show edit update destroy]

    def index
        # @board = Board.all
        @board = Board.page(params[:page]) # kaminariのページメソッド(25件)
    end

    # 新規作成 new(get), create(post)
    def new
        # @board = Board.new
        @board = Board.new(flash[:board]) # createに失敗した時、入力データはそのままにする
        # binding.pry
    end
    
    # newで登録したやつを、POSTで受け取って作成 paramsにPOSTで送信されたデータが保存される params[:board]に必要なやつが入っている
    # flashのnoticeというキーに値を格納
    def create
        # Board.create(board_params) # validateやらないなら、createでOK
        board =  Board.new(board_params)
        if board.save
            flash[:notice] = "「#{params[:board][:title]}」の掲示板を作成しました。"
            redirect_to root_path
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
        @comment = @board.comments.new
        @comments = Comment.all
        # binding.pry
    end

    # 編集edit(get), update(post)
    def edit
    end

    def update
        @board.update(board_params)
        flash[:notice] = "「#{@board.title}」 の掲示板を更新しました。"
        redirect_to root_path
    end
    
    def destroy
        @board.destroy # deleteでもいける
        # flash[:error] = "「#{@board.title}」 の掲示板を削除しました。" # redirectにくっつける書き方もある
        redirect_to boards_path, flash: { error: "「#{@board.title}」 の掲示板を削除しました。" }
    end

    private # これより下に、普通のは置かない
    
    # 必要ないのを受け取らないように、strong parameterで制限する
    def board_params
        params.require(:board).permit(:name, :title, :body)
    end

    def set_board
        # show create edit update destroyの一番上で実行されるから、消す
        @board = Board.find(params[:id])
    end
end


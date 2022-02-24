class BoardsController < ApplicationController

    # 最初に指定したメソッドで実行(このメソッドの中に@boardの文が入る)
    before_action :set_board, only: %i[show create edit update destroy]

    def index
        # @board = Board.all
        @board = Board.page(params[:page]) # kaminariのページメソッド(25件)
    end

    # 新規作成 new(get), create(post)
    def new
        @board = Board.new
        # binding.pry
    end

    # filterを掛けるために、strong parameter(board_params)
    def create
        # newで登録したやつを、POSTで受け取って作成
        # paramsにPOSTで送信されたデータが保存される
        # params[:board]に必要なやつ
        @board = Board.find(params[:id])
        Board.create(board_params)
        # flashの任意のキーに値を格納
        flash[:notice] = "「#{@board.title}」の掲示板を作成しました。"
        redirect_to boards_path
    end

    # 動的(get)
    def show
        # @board = Board.find(params[:id])
    end

    # 編集edit(get), update(post)
    def edit
        # @board = Board.find(params[:id])
    end

    def update
        # @board = Board.find(params[:id])
        @board.update(board_params)
        flash[:notice] = "「#{@board.title}」の掲示板を更新しました。"
        redirect_to root_path
    end
    
    def destroy
        # @board = Board.find(params[:id])
        @board.destroy # deleteでもいける
        redirect_to boards_path # boardが出来ないなら、boards_path
    end

    # これより下に、普通のは置かない
    private
    
    def board_params
        params.require(:board).permit(:name, :title, :body)
    end

    def set_board
        # show create edit update destroyの一番上で実行されるから、消す
        @board = Board.find(params[:id])
    end
end


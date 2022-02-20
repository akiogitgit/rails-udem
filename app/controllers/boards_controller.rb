class BoardsController < ApplicationController
    def index
        @board = Board.all
    end

    # 新規作成 new(get), create(post)
    def new
        @board = Board.new
        # binding.pry
    end

    # filterを掛けるために、strong parameter
    def create
        # newで登録したやつを、POSTで受け取って作成
        # paramsにPOSTで送信されたデータが保存される
        # params[:board]に必要なやつ
        Board.create(board_params)
        redirect_to root_path
    end

    # 動的(get)
    def show
        # binding.pry
        @board = Board.find(params[:id])
    end

    # 編集edit(get), update(post)
    def edit
        @board = Board.find(params[:id])
    end

    def update
        board = Board.find(params[:id])
        board.update(board_params)
        redirect_to root_path
    end
    
    def destroy
        # board = Board.find(params[:id])
        @board.destroy
        # redirect_to boards_path
        redirect_to board
    end

    # これより下に、普通のは置かない
    private
    
    def board_params
        params.require(:board).permit(:name, :title, :body)
    end

end

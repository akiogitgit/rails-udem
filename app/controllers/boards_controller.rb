class BoardsController < ApplicationController
    def index
        @board = Board.all
    end

    def new
        @board = Board.new
        # binding.pry
    end

    # filterを掛けるために、strong parameter
    def create
        # newで登録したやつを、POSTで受け取って作成
        Board.create(board_params)
        # binding.pry
        # paramsにPOSTで送信されたデータが保存される
        # params[:board]に必要なやつ
    end

    private
    
    def board_params
        params.require(:board).permit(:name, :title, :body)
    end
end

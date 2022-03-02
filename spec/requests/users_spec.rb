require 'rails_helper'

RSpec.describe "Users", type: :request do
  # Getメソッドの時
  describe "GET /users/new" do
    it "新規作成画面の表示に成功すること" do
      get new_user_path
      expect(response).to have_http_status(200)
      # puts response.body
    end
  end
end

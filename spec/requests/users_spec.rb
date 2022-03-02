require 'rails_helper'

RSpec.describe "Users", type: :request do
  # Getメソッドのnew アクションについて
  describe "GET #new" do
    # before { get :new } # 全itで実行
    before { get new_user_path }

    it "レスポンスコードが200であること" do
      # get new_user_path # 上に移す
      # expect(response).to have_http_status(200)
      expect(response).to have_http_status(:ok) # :ok で200と同じ
    end

    it "h1タグがあること" do
      expect(response.body).to match(/<h1>ユーザー登録/i)
    end
  end

  describe "POST #create" do
    context "正しいユーザー情報が渡ってきた場合" do
      let(:params) do
        { user: {
            name: "user",
            password: "password",
            password_confirmation: "password",
          }
        }
      end

      it "ユーザーが一人増えていること" do
        expect { post :create, params: params }.to change(User, :count).by(1)
      end

      it "マイページにリダイレクトされること" do
        expect(post :create, params: params).to redirect_to(mypage_path)
      end
    end
  end
end

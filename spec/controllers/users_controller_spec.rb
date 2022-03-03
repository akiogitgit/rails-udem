require "rails_helper"

# テストできない
RSpec.describe UsersController, type: :controller do
  # Getメソッドのnew アクションについて
  describe "GET #new" do
    before { get :new } # 全itで実行
    # before { get new_user_path }

    it "レスポンスコードが200であること" do
      # get new_user_path # 上に移す
      expect(response).to have_http_status(200)
      # puts response.body
    end

    it "newテンプレートをレンダリングすること" do
      expect(response).to render_template :new
    end

    it "新しいuserオブジェクトがビューに渡されること" do
      expect(assigns(:user)).to be_a_new User
    end
  end

  # createアクション
  describe "POST #create" do
    before do
      @referer = "http://localhost"
      @request.env["HTTP_REFERER"] = @referer
    end

    context "正しいユーザー情報が渡ってきた場合" do
      # params で参照できるようにする 全て正しい情報
      let(:params) do
        { user: {
            name: "user",
            password: "password",
            password_confirmation: "password",
          }
        }
      end

      it "ユーザーが一人増えていること" do
        # expectの前と後で比較する
        expect { post :create, params: params }.to change(User, :count).by(1)
      end

      it "マイページにリダイレクトされること" do
        # createが成功したら、mypageに遷移するか
        expect(post :create, params: params).to redirect_to(mypage_path)
      end
    end

    context "パラメータに正しいユーザー名、確認パスワードが含まれていない場合" do
      before do
        # 謝ったデータ
        post(:create, params: {
          user: {
            name: "ユーザー1",
            password: "password",
            password_confirmation: "invalid_password"
          }
        })
      end
      
      # ここにリダイレクトするよね？
      it "リファラーにリダイレクトされること" do
        expect(response).to redirect_to(@referer)
      end

      it "ユーザー名のエラーメッセージが含まれていること" do
        expect(flash[:error_messages]).to include "ユーザー名小文字英数字で入力してください"
      end

      it "パスワード確認のエラーメッセージが含まれていること" do
        expect(flash[:error_messages]).to include "パスワード(確認)とパスワードの入力が一致しません"
      end
    end
  end
end
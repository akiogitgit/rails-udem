# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  birthday        :date
#  name            :string           not null
#  password_digest :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
# Indexes
#
#  index_users_on_name  (name) UNIQUE
#
require 'rails_helper'

RSpec.describe User, type: :model do
  # これは、テストがない時に保留するためのコード
  # pending "add some examples to (or delete) #{__FILE__}"

  # ageメソッドをテスト
  describe "#age" do
    # 最初に実行(モックデータ)
    before do
      # Time.zone.now を呼んdだら、2018/04/01を返す
      allow(Time.zone).to receive(:now).and_return(Time.zone.parse("2018/04/01"))
    end

    context "20年前の生年月日の場合" do # testの説明
      # userという変数に、Use.newで作成したオブジェクトを代入
      let(:user) { User.new(birthday: Time.zone.now - 20.years) }

      # 最終的にどの状態が正しいかをテスト
      it "年齢が20歳であること" do
        # ここが大事user.ageが20かをテスト
        expect(user.age).to eq 20 # user.age = 20ならOK！
      end  
    end

    context "10年前に生まれた場合でちょうど誕生日の場合" do
      let(:user) { User.new(birthday: Time.zone.parse("2008/04/01")) }

      it "年齢が10歳であること" do
        expect(user.age).to eq 10
      end
    end

    context "10年前に生まれて誕生日が来てない場合" do
      let(:user) { User.new(birthday: Time.zone.parse("2008/04/02")) }

      it "年齢が9歳であること" do
        expect(user.age).to eq 9
      end
    end
  end
end

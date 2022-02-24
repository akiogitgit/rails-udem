class CreateComments < ActiveRecord::Migration[7.0]
  def change
    create_table :comments do |t|
      # board:referencesで生成, 存在しないBoardのidは許可許可しない
      t.references :board, null: false, foreign_key: true
      t.string :name, null: false
      t.text :comment, null: false

      t.timestamps
    end
  end
end

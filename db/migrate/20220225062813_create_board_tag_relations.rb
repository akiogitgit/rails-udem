class CreateBoardTagRelations < ActiveRecord::Migration[7.0]

  # boardと、tagが紐づいている。中間テーブルになっている
  def change
    create_table :board_tag_relations do |t|
      t.references :board, null: false, foreign_key: true
      t.references :tag, null: false, foreign_key: true

      t.timestamps
    end
  end
end

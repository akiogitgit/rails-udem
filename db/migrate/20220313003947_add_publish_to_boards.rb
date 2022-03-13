class AddPublishToBoards < ActiveRecord::Migration[7.0]
  def change
    add_column :boards, :published, :boolean, default: true
    add_column :boards, :liked, :integer, default: 0
  end
end

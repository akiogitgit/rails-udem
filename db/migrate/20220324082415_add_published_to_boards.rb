class AddPublishedToBoards < ActiveRecord::Migration[7.0]
  def change
    add_column :boards, :published, :boolean, default: true
  end
end

class AddPrivateToBoards < ActiveRecord::Migration[7.0]
  def change
    add_column :boards, :private, :boolean, default: true
  end
end

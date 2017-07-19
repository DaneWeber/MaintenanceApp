class AddIndexToChores < ActiveRecord::Migration[5.1]
  def change
    add_index :chores, :nextdue
  end
end

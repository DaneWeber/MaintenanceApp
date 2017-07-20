class RemoveUntouchedFromChores < ActiveRecord::Migration[5.1]
  def change
    remove_column :chores, :untouched, :boolean
  end
end

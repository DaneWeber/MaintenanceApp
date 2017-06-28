class AddNextLastUntouchedToChores < ActiveRecord::Migration[5.1]
  def change
    add_column :chores, :lastdone, :date
    add_column :chores, :nextdue, :date
    add_column :chores, :untouched, :boolean
  end
end

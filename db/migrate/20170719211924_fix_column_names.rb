class FixColumnNames < ActiveRecord::Migration[5.1]
  def change
    rename_column :chores, :last_done, :last_done
    rename_column :chores, :next_due, :next_due
  end
end

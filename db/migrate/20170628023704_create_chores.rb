class CreateChores < ActiveRecord::Migration[5.1]
  def change
    create_table :chores do |t|
      t.string :name
      t.text :instructions
      t.integer :interval_days

      t.timestamps
    end
  end
end

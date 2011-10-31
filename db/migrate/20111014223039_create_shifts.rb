class CreateShifts < ActiveRecord::Migration
  def change
    create_table :shifts do |t|
      t.integer :chore_id, :null => false
      t.integer :user_id
      t.integer :day_of_week
      t.time :time
      t.integer :temporary

      t.timestamps
    end
  end
end

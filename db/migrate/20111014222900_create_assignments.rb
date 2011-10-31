class CreateAssignments < ActiveRecord::Migration
  def change
    create_table :assignments do |t|
      t.integer :user_id, :null => false
      t.integer :shift_id, :null => false
      t.integer :week
      t.integer :status
      t.string :blow_off_job_id

      t.timestamps
    end
  end
end

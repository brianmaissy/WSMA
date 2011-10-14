class CreateAssignments < ActiveRecord::Migration
  def change
    create_table :assignments do |t|
      t.integer :week
      t.integer :status
      t.string :blow_off_job_id

      t.timestamps
    end
  end
end

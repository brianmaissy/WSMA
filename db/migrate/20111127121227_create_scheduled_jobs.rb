class CreateScheduledJobs < ActiveRecord::Migration
  def change
    create_table :scheduled_jobs do |t|
      t.datetime :time
      t.string :tag
      t.string :target_class
      t.integer :target_id

      t.timestamps
    end
  end
end

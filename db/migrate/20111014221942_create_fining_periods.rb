class CreateFiningPeriods < ActiveRecord::Migration
  def change
    create_table :fining_periods do |t|
      t.integer :house_id, :null => false
      t.integer :fining_week
      t.decimal :fine_for_hours_below
      t.decimal :fine_per_hour_below
      t.decimal :forgive_percentage_of_fined_hours
      t.string :fine_job_id

      t.timestamps
    end
  end
end

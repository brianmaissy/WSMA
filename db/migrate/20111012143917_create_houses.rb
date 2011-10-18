class CreateHouses < ActiveRecord::Migration
  def change
    create_table :houses do |t|
      t.string :name
      t.date :semester_start_date
      t.integer :weeks_in_semester
      t.integer :permanent_chores_start_week
      t.decimal :hours_per_week
      t.decimal :sign_off_by_hours_after
      t.integer :using_online_sign_off
      t.integer :sign_off_verification_mode
      t.decimal :blow_off_penalty_factor
      t.string :new_week_job_id
      t.string :wsm_email

      t.timestamps
    end
  end
end

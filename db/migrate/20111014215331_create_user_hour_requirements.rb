class CreateUserHourRequirements < ActiveRecord::Migration
  def change
    create_table :user_hour_requirements do |t|
      t.integer :user_id, :null => false
      t.integer :week
      t.decimal :hours

      t.timestamps
    end
  end
end

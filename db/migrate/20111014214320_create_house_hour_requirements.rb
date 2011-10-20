class CreateHouseHourRequirements < ActiveRecord::Migration
  def change
    create_table :house_hour_requirements do |t|
      t.integer :house_id, :null => false
      t.integer :week
      t.decimal :hours

      t.timestamps
    end
  end
end

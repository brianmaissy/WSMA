class CreateHouseHourRequirements < ActiveRecord::Migration
  def change
    create_table :house_hour_requirements do |t|
      t.integer :week
      t.decimal :hours

      t.timestamps
    end
  end
end

class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.integer :house_id, :null => false
      t.string :email
      t.string :hashed_password
      t.string :salt
      t.string :jom_social_id
      t.integer :access_level
      t.string :name
      t.string :phone_number
      t.string :room_number
      t.decimal :hours_per_week
      t.text :notes

      t.timestamps
    end
  end
end

class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.integer :house_id, :null => false
      t.string :email
      t.string :password_hash
      t.string :jom_social_id
      t.integer :access_level
      t.string :name
      t.string :phone_number
      t.string :room_number
      t.decimal :hours_per_week
      t.text :notes
      t.string :password_reset_token
      t.datetime :token_expiration
      t.timestamps
    end
  end
end

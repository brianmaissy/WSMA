class CreateEncryptedConnections < ActiveRecord::Migration
  def change
    create_table :encrypted_connections do |t|
      t.text :public_key
      t.text :private_key

      t.timestamps
    end
  end
end

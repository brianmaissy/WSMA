class CreateFines < ActiveRecord::Migration
  def change
    create_table :fines do |t|
      t.integer :user_id, :null => false
      t.integer :fining_period_id
      t.decimal :amount
      t.integer :paid
      t.date :paid_date
      t.decimal :hours_fined_for

      t.timestamps
    end
  end
end

class CreateFines < ActiveRecord::Migration
  def change
    create_table :fines do |t|
      t.decimal :amount
      t.integer :paid
      t.date :paid_date
      t.decimal :hours_fined_for

      t.timestamps
    end
  end
end

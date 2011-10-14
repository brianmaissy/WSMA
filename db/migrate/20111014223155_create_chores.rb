class CreateChores < ActiveRecord::Migration
  def change
    create_table :chores do |t|
      t.string :name
      t.string :description
      t.decimal :hours
      t.decimal :sign_out_by_hours_before
      t.decimal :due_hours_after

      t.timestamps
    end
  end
end

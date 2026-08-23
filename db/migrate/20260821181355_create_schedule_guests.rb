class CreateScheduleGuests < ActiveRecord::Migration[8.1]
  def change
    create_table :schedule_guests do |t|
      t.references :schedule_item, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      
      t.integer :status, default: 0, null: false
      
      t.timestamps
    end
    
    add_index :schedule_guests, [:schedule_item_id, :user_id], unique: true
  end
end
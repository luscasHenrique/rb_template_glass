class CreateScheduleItems < ActiveRecord::Migration[8.1]
  def change
    create_table :schedule_items do |t|
      t.string :title, null: false
      t.text :description
      t.datetime :start_time, null: false
      t.datetime :end_time
      t.string :meeting_url
      
      t.integer :item_type, default: 0, null: false
      
      t.references :creator, null: false, foreign_key: { to_table: :users }
      
      t.references :location, polymorphic: true

      t.timestamps
    end
  end
end
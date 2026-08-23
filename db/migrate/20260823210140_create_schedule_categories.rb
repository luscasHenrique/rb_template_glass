class CreateScheduleCategories < ActiveRecord::Migration[8.1]
  def change
    create_table :schedule_categories do |t|
      t.string :name
      t.string :color
      t.string :icon
      t.boolean :active

      t.timestamps
    end
  end
end

class UpdateScheduleItemsForDynamicCategories < ActiveRecord::Migration[8.1]
  def change
    add_reference :schedule_items, :schedule_category, foreign_key: true
    remove_column :schedule_items, :item_type, :integer
  end
end

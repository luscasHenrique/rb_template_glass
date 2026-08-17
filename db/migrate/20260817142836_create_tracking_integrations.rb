class CreateTrackingIntegrations < ActiveRecord::Migration[8.1]
  def change
    create_table :tracking_integrations do |t|
      t.string :provider_name
      t.string :account_id
      t.boolean :is_active

      t.timestamps
    end
  end
end

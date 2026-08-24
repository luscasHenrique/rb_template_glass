class CreateScheduleDelegations < ActiveRecord::Migration[8.1]
  def change
    create_table :schedule_delegations do |t|
      t.integer :delegator_id
      t.integer :delegate_id

      t.timestamps
    end
  end
end

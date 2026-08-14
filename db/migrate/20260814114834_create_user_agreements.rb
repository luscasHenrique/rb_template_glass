class CreateUserAgreements < ActiveRecord::Migration[8.1]
  def change
    create_table :user_agreements do |t|
      t.references :user, null: false, foreign_key: true
      t.references :policy_term, null: false, foreign_key: true
      t.datetime :accepted_at
      t.string :ip_address

      t.timestamps
    end
  end
end

class CreateProfiles < ActiveRecord::Migration[8.1]
  def change
    create_table :profiles do |t|
      t.references :user, null: false, foreign_key: true
      t.string :first_name
      t.string :last_name
      t.string :avatar_url
      t.string :phone
      t.text :bio

      t.timestamps
    end
  end
end

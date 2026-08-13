class CreateAddresses < ActiveRecord::Migration[8.1]
  def change
    create_table :addresses do |t|
      t.references :addressable, polymorphic: true, null: false
      t.string :street
      t.string :number
      t.string :city
      t.string :state
      t.string :zip_code

      t.timestamps
    end
  end
end

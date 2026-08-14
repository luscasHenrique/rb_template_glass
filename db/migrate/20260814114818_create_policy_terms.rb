class CreatePolicyTerms < ActiveRecord::Migration[8.1]
  def change
    create_table :policy_terms do |t|
      t.string :version
      t.text :content
      t.boolean :active

      t.timestamps
    end
  end
end

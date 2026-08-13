class AddComplementToAddresses < ActiveRecord::Migration[8.1]
  def change
    add_column :addresses, :complement, :string
  end
end

class AddBirthDateToProfiles < ActiveRecord::Migration[8.1]
  def change
    add_column :profiles, :birth_date, :date
  end
end

class AddActiveColumnToOffice < ActiveRecord::Migration[7.0]
  def change
    add_column :offices, :active, :boolean, default: true, after: :renamed
  end
end

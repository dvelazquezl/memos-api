class AddSizesToPeriod < ActiveRecord::Migration[7.0]
  def change
    add_column :periods, :header_width, :float
    add_column :periods, :header_height, :float
    add_column :periods, :footer_width, :float
    add_column :periods, :footer_height, :float
  end
end

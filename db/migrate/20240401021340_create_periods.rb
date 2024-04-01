class CreatePeriods < ActiveRecord::Migration[7.0]
  def change
    create_table :periods do |t|
      t.string :header_url
      t.string :footer_url
      t.datetime :start_date
      t.datetime :end_date
      t.boolean :active, null: false, default: false

      t.timestamps
    end
    add_index :periods, :id, unique: true
  end
end

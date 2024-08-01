class CreatePeriods < ActiveRecord::Migration[7.0]
  def change
    create_table :periods do |t|
      t.string :header_url, null: false
      t.string :footer_url, null: false
      t.datetime :start_date, null: false
      t.datetime :end_date, null: false
      t.boolean :active, null: false, default: false

      t.timestamps
    end
    add_index :periods, :id, unique: true
  end
end

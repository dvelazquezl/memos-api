class CreateOffices < ActiveRecord::Migration[7.0]
  def change
    create_table :offices do |t|
      t.string :office_name, null: false

      t.timestamps
    end
    add_index :offices, :id, unique: true
  end
end

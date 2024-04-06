class CreateOffices < ActiveRecord::Migration[7.0]
  def change
    create_table :offices do |t|
      t.string :name, null: false
      t.boolean :renamed

      t.timestamps
    end
    add_index :offices, :id, unique: true
  end
end

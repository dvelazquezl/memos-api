class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.integer :id_number, null: false
      t.string :full_name
      t.string :email
      t.string :username, null: false
      t.column :position, "ENUM('boss', 'secretary')"
      t.bigint :office_id, null: false

      t.timestamps
    end
    add_index :users, :id, unique: true
  end
end

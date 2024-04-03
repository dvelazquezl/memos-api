class CreateUsers < ActiveRecord::Migration[7.0]
  def change
    create_table :users do |t|
      t.integer :ci_number, null: false
      t.string :full_name, null: false
      t.string :email, null: false
      t.string :username, null: false
      t.column :position, "ENUM('boss', 'secretary')", null: false
      t.bigint :office_id, null: false

      t.timestamps
    end
    add_index :users, :id, unique: true
  end
end

class CreateOfficesRenameHistory < ActiveRecord::Migration[7.0]
  def change
    create_table :offices_rename_history do |t|
      t.bigint :old_office_id, null: false
      t.bigint :replacement_office_id, null: false

      t.timestamps
    end
    add_index :offices_rename_history, :id, unique: true
  end
end

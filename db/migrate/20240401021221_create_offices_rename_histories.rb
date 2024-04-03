class CreateOfficesRenameHistories < ActiveRecord::Migration[7.0]
  def change
    create_table :offices_rename_histories do |t|
      t.bigint :office_id, null: false
      t.string :name, null: false
      t.bigint :period_id, null: false

      t.timestamps
    end
    add_index :offices_rename_histories, :id, unique: true
  end
end

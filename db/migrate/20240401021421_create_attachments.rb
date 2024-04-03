class CreateAttachments < ActiveRecord::Migration[7.0]
  def change
    create_table :attachments do |t|
      t.string :url, null: false
      t.bigint :memo_id, null: false

      t.timestamps
    end
    add_index :attachments, :id, unique: true
  end
end

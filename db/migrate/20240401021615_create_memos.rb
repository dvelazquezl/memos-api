class CreateMemos < ActiveRecord::Migration[7.0]
  def change
    create_table :memos do |t|
      t.text :subject, null: false
      t.datetime :memo_date, null: false
      t.text :body
      t.column :status, "ENUM('draft', 'approved')"
      t.datetime :deadline
      t.bigint :created_by, null: false
      t.bigint :office_id, null: false
      t.bigint :period_id, null: false
      t.bigint :memo_to_reply

      t.timestamps
    end
    add_index :memos, :id, unique: true
  end
end

class CreateMemos < ActiveRecord::Migration[7.0]
  def change
    create_table :memos do |t|
      t.text :subject
      t.datetime :memo_date
      t.text :body
      t.column :status, "ENUM('draft', 'finished')"
      t.datetime :deadline
      t.bigint :created_by
      t.bigint :office_id
      t.bigint :period_id
      t.bigint :memo_to_reply

      t.timestamps
    end
    add_index :memos, :id, unique: true
  end
end

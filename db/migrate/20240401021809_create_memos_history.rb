class CreateMemosHistory < ActiveRecord::Migration[7.0]
  def change
    create_table :memos_history do |t|
      t.bigint :memo_id, null: false
      t.integer :memo_number
      t.bigint :office_receiver_id, null: false
      t.bigint :office_sender_id, null: false
      t.datetime :sent_at
      t.boolean :received
      t.datetime :received_at
      t.bigint :received_by, null: false
      t.string :comment

      t.timestamps
    end
    add_index :memos_history, :id, unique: true
  end
end

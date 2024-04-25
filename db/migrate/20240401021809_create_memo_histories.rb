class CreateMemoHistories < ActiveRecord::Migration[7.0]
  def change
    create_table :memo_histories do |t|
      t.bigint :memo_id, null: false
      t.integer :memo_number, null: false
      t.bigint :office_receiver_id
      t.bigint :office_sender_id
      t.datetime :sent_at
      t.boolean :received
      t.datetime :received_at
      t.bigint :received_by
      t.string :comment

      t.timestamps
    end
    add_index :memo_histories, :id, unique: true
  end
end

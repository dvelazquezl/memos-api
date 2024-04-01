class RelationMemosHistory < ActiveRecord::Migration[7.0]
  def change
    add_foreign_key :memos_history, :memos, column: :memo_id
    add_foreign_key :memos_history, :offices, column: :office_receiver_id
    add_foreign_key :memos_history, :offices, column: :office_sender_id
    add_foreign_key :memos_history, :users, column: :received_by
  end
end

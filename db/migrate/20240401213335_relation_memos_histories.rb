class RelationMemosHistories < ActiveRecord::Migration[7.0]
  def change
    add_foreign_key :memos_histories, :memos, column: :memo_id
    add_foreign_key :memos_histories, :offices, column: :office_receiver_id
    add_foreign_key :memos_histories, :offices, column: :office_sender_id
    add_foreign_key :memos_histories, :users, column: :received_by
  end
end

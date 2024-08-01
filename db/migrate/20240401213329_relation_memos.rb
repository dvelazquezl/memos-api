class RelationMemos < ActiveRecord::Migration[7.0]
  def change
    add_foreign_key :memos, :users, column: :created_by
    add_foreign_key :memos, :offices, column: :office_id
    add_foreign_key :memos, :periods, column: :period_id
    add_foreign_key :memos, :memos, column: :memo_to_reply
  end
end

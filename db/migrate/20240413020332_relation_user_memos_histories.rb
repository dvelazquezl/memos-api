class RelationUserMemosHistories < ActiveRecord::Migration[7.0]
  def change
    add_foreign_key :memos_histories, :users, column: :sent_by
  end
end

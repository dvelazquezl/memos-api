class AddUserToMemosHistories < ActiveRecord::Migration[7.0]
  def change
    add_column :memos_histories, :sent_by, :bigint, null: false
  end
end

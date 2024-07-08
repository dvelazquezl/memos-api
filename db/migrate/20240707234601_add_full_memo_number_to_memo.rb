class AddFullMemoNumberToMemo < ActiveRecord::Migration[7.0]
  def change
    add_column :memos, :full_memo_number, :string, after: :offices_receiver_ids
  end
end

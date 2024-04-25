class AddUserToMemoHistories < ActiveRecord::Migration[7.0]
  def change
    add_column :memo_histories, :sent_by, :bigint
  end
end

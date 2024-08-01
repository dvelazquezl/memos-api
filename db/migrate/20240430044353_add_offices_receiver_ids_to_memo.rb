class AddOfficesReceiverIdsToMemo < ActiveRecord::Migration[7.0]
  def change
    add_column :memos, :offices_receiver_ids, :string, default: '', null: false, after: :memo_to_reply
  end
end

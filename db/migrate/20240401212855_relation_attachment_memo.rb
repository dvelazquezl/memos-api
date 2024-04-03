class RelationAttachmentMemo < ActiveRecord::Migration[7.0]
  def change
    add_foreign_key :attachments, :memos, column: :memo_id
  end
end

class RelationUserAttachments < ActiveRecord::Migration[7.0]
  def change
    add_foreign_key :attachments, :users, column: :user_id
  end
end

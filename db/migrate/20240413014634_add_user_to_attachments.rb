class AddUserToAttachments < ActiveRecord::Migration[7.0]
  def change
    add_column :attachments, :user_id, :bigint, null: false
  end
end

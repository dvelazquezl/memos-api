class AddFileNameToAttachments < ActiveRecord::Migration[7.0]
  def change
    add_column :attachments, :file_name, :string, null: false, after: :memo_id
  end
end

class RelationOfficeRenameHistories < ActiveRecord::Migration[7.0]
  def change
    add_foreign_key :office_rename_histories, :offices, column: :office_id
    add_foreign_key :office_rename_histories, :periods, column: :period_id
  end
end

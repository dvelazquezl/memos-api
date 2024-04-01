class RelationOfficeRenameHistory < ActiveRecord::Migration[7.0]
  def change
    add_foreign_key :offices_rename_history, :offices, column: :old_office_id
    add_foreign_key :offices_rename_history, :offices, column: :replacement_office_id
  end
end

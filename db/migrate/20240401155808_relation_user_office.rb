class RelationUserOffice < ActiveRecord::Migration[7.0]
  def change
    add_foreign_key :users, :offices, column: :office_id
  end
end

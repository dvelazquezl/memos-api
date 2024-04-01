# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.0].define(version: 2024_04_01_213335) do
  create_table "attachments", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "url"
    t.bigint "memo_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["id"], name: "index_attachments_on_id", unique: true
    t.index ["memo_id"], name: "fk_rails_ab8ea4fafe"
  end

  create_table "memos", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.text "subject"
    t.datetime "memo_date"
    t.text "body"
    t.column "status", "enum('draft','finished')"
    t.datetime "deadline"
    t.bigint "created_by"
    t.bigint "office_id"
    t.bigint "period_id"
    t.bigint "memo_to_reply"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_by"], name: "fk_rails_a99c2dc451"
    t.index ["id"], name: "index_memos_on_id", unique: true
    t.index ["memo_to_reply"], name: "fk_rails_816f0b718e"
    t.index ["office_id"], name: "fk_rails_177958be33"
    t.index ["period_id"], name: "fk_rails_d33e6f5694"
  end

  create_table "memos_history", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "memo_id", null: false
    t.integer "memo_number"
    t.bigint "office_receiver_id", null: false
    t.bigint "office_sender_id", null: false
    t.datetime "sent_at"
    t.boolean "received"
    t.datetime "received_at"
    t.bigint "received_by", null: false
    t.string "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["id"], name: "index_memos_history_on_id", unique: true
    t.index ["memo_id"], name: "fk_rails_c932eef047"
    t.index ["office_receiver_id"], name: "fk_rails_24fcbd58a0"
    t.index ["office_sender_id"], name: "fk_rails_18f8e3b86c"
    t.index ["received_by"], name: "fk_rails_2c19a43bc4"
  end

  create_table "offices", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "office_name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["id"], name: "index_offices_on_id", unique: true
  end

  create_table "offices_rename_history", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.bigint "old_office_id", null: false
    t.bigint "replacement_office_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["id"], name: "index_offices_rename_history_on_id", unique: true
    t.index ["old_office_id"], name: "fk_rails_bd33f75616"
    t.index ["replacement_office_id"], name: "fk_rails_0d6decfe2a"
  end

  create_table "periods", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.string "header_url"
    t.string "footer_url"
    t.datetime "start_date"
    t.datetime "end_date"
    t.boolean "active", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["id"], name: "index_periods_on_id", unique: true
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_general_ci", force: :cascade do |t|
    t.integer "id_number", null: false
    t.string "full_name"
    t.string "email"
    t.string "username", null: false
    t.column "position", "enum('boss','secretary')"
    t.bigint "office_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["id"], name: "index_users_on_id", unique: true
    t.index ["office_id"], name: "fk_rails_547b85a38b"
  end

  add_foreign_key "attachments", "memos"
  add_foreign_key "memos", "memos", column: "memo_to_reply"
  add_foreign_key "memos", "offices"
  add_foreign_key "memos", "periods"
  add_foreign_key "memos", "users", column: "created_by"
  add_foreign_key "memos_history", "memos"
  add_foreign_key "memos_history", "offices", column: "office_receiver_id"
  add_foreign_key "memos_history", "offices", column: "office_sender_id"
  add_foreign_key "memos_history", "users", column: "received_by"
  add_foreign_key "offices_rename_history", "offices", column: "old_office_id"
  add_foreign_key "offices_rename_history", "offices", column: "replacement_office_id"
  add_foreign_key "users", "offices"
end

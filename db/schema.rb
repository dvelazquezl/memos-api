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

ActiveRecord::Schema[7.0].define(version: 2024_09_10_015012) do
  create_table "attachments", charset: "utf8mb4", collation: "utf8mb4_uca1400_ai_ci", force: :cascade do |t|
    t.string "url", null: false
    t.bigint "memo_id", null: false
    t.string "file_name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.index ["id"], name: "index_attachments_on_id", unique: true
    t.index ["memo_id"], name: "fk_rails_ab8ea4fafe"
    t.index ["user_id"], name: "fk_rails_5650a5e7db"
  end

  create_table "memo_histories", charset: "utf8mb4", collation: "utf8mb4_uca1400_ai_ci", force: :cascade do |t|
    t.bigint "memo_id", null: false
    t.integer "memo_number", null: false
    t.bigint "office_receiver_id"
    t.bigint "office_sender_id"
    t.datetime "sent_at"
    t.boolean "received"
    t.datetime "received_at"
    t.bigint "received_by"
    t.string "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "sent_by"
    t.index ["id"], name: "index_memo_histories_on_id", unique: true
    t.index ["memo_id"], name: "fk_rails_df4433091c"
    t.index ["office_receiver_id"], name: "fk_rails_812cd0d713"
    t.index ["office_sender_id"], name: "fk_rails_beec34e6d3"
    t.index ["received_by"], name: "fk_rails_2d7f7b6f80"
    t.index ["sent_by"], name: "fk_rails_cd67f3f6c6"
  end

  create_table "memos", charset: "utf8mb4", collation: "utf8mb4_uca1400_ai_ci", force: :cascade do |t|
    t.text "subject", null: false
    t.datetime "memo_date", null: false
    t.text "body"
    t.integer "status", default: 0, null: false, unsigned: true
    t.datetime "deadline"
    t.bigint "created_by", null: false
    t.bigint "office_id", null: false
    t.bigint "period_id", null: false
    t.bigint "memo_to_reply"
    t.string "offices_receiver_ids", default: "", null: false
    t.string "full_memo_number"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_by"], name: "fk_rails_a99c2dc451"
    t.index ["id"], name: "index_memos_on_id", unique: true
    t.index ["memo_to_reply"], name: "fk_rails_816f0b718e"
    t.index ["office_id"], name: "fk_rails_177958be33"
    t.index ["period_id"], name: "fk_rails_d33e6f5694"
  end

  create_table "office_rename_histories", charset: "utf8mb4", collation: "utf8mb4_uca1400_ai_ci", force: :cascade do |t|
    t.bigint "office_id", null: false
    t.string "name", null: false
    t.bigint "period_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["id"], name: "index_office_rename_histories_on_id", unique: true
    t.index ["office_id"], name: "fk_rails_278ca9a55d"
    t.index ["period_id"], name: "fk_rails_1d322f9822"
  end

  create_table "offices", charset: "utf8mb4", collation: "utf8mb4_uca1400_ai_ci", force: :cascade do |t|
    t.string "name", null: false
    t.boolean "renamed", default: false
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["id"], name: "index_offices_on_id", unique: true
  end

  create_table "periods", charset: "utf8mb4", collation: "utf8mb4_uca1400_ai_ci", force: :cascade do |t|
    t.string "header_url", null: false
    t.string "footer_url", null: false
    t.datetime "start_date", null: false
    t.datetime "end_date", null: false
    t.boolean "active", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.float "header_width"
    t.float "header_height"
    t.float "footer_width"
    t.float "footer_height"
    t.index ["id"], name: "index_periods_on_id", unique: true
  end

  create_table "users", charset: "utf8mb4", collation: "utf8mb4_uca1400_ai_ci", force: :cascade do |t|
    t.integer "ci_number", null: false
    t.string "full_name", null: false
    t.string "email", null: false
    t.string "username", null: false
    t.integer "role", default: 0, null: false, unsigned: true
    t.bigint "office_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "password_digest"
    t.boolean "active", default: true
    t.index ["id"], name: "index_users_on_id", unique: true
    t.index ["office_id"], name: "fk_rails_547b85a38b"
  end

  add_foreign_key "attachments", "memos"
  add_foreign_key "attachments", "users"
  add_foreign_key "memo_histories", "memos"
  add_foreign_key "memo_histories", "offices", column: "office_receiver_id"
  add_foreign_key "memo_histories", "offices", column: "office_sender_id"
  add_foreign_key "memo_histories", "users", column: "received_by"
  add_foreign_key "memo_histories", "users", column: "sent_by"
  add_foreign_key "memos", "memos", column: "memo_to_reply"
  add_foreign_key "memos", "offices"
  add_foreign_key "memos", "periods"
  add_foreign_key "memos", "users", column: "created_by"
  add_foreign_key "office_rename_histories", "offices"
  add_foreign_key "office_rename_histories", "periods"
  add_foreign_key "users", "offices"
end

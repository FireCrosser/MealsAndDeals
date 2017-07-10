# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20170710201711) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "course", force: :cascade do |t|
    t.string "name", null: false
    t.float "price", null: false
    t.datetime "date", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "course_type_id", null: false
    t.string "image"
    t.index ["course_type_id"], name: "index_course_on_course_type_id"
  end

  create_table "course_type", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_course_type_on_name", unique: true
  end

  create_table "order", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["user_id"], name: "index_order_on_user_id"
  end

  create_table "ordered_course", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "order_id", null: false
    t.bigint "course_id", null: false
    t.index ["course_id"], name: "index_ordered_course_on_course_id"
    t.index ["order_id"], name: "index_ordered_course_on_order_id"
  end

  create_table "role", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_role_on_name", unique: true
  end

  create_table "user", force: :cascade do |t|
    t.string "name", null: false
    t.string "email", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "role_id", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "auth_token"
    t.index ["email"], name: "index_user_on_email", unique: true
    t.index ["reset_password_token"], name: "index_user_on_reset_password_token", unique: true
    t.index ["role_id"], name: "index_user_on_role_id"
  end

  add_foreign_key "course", "course_type"
  add_foreign_key "order", "\"user\"", column: "user_id"
  add_foreign_key "ordered_course", "\"order\"", column: "order_id"
  add_foreign_key "ordered_course", "course"
  add_foreign_key "user", "role"
end

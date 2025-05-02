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

ActiveRecord::Schema[8.0].define(version: 2025_05_02_125636) do
  create_table "course_enrollments", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "course_id", null: false
    t.datetime "started_at"
    t.datetime "completed_at"
    t.integer "progress_percentage", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_course_enrollments_on_course_id"
    t.index ["user_id", "course_id"], name: "index_course_enrollments_on_user_id_and_course_id", unique: true
    t.index ["user_id"], name: "index_course_enrollments_on_user_id"
  end

  create_table "courses", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "lesson_completions", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "lesson_id", null: false
    t.datetime "started_at"
    t.datetime "completed_at"
    t.boolean "completed", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lesson_id"], name: "index_lesson_completions_on_lesson_id"
    t.index ["user_id", "lesson_id"], name: "index_lesson_completions_on_user_id_and_lesson_id", unique: true
    t.index ["user_id"], name: "index_lesson_completions_on_user_id"
  end

  create_table "lessons", force: :cascade do |t|
    t.string "title"
    t.text "description"
    t.integer "course_id", null: false
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "lesson_content"
    t.index ["course_id"], name: "index_lessons_on_course_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "admin", default: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "course_enrollments", "courses"
  add_foreign_key "course_enrollments", "users"
  add_foreign_key "lesson_completions", "lessons"
  add_foreign_key "lesson_completions", "users"
  add_foreign_key "lessons", "courses"
end

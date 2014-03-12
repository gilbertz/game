# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20140312035117) do

  create_table "answers", force: true do |t|
    t.string   "title"
    t.integer  "group"
    t.string   "img"
    t.integer  "viewable_id"
    t.string   "viewable_type"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "answers", ["viewable_id", "viewable_type"], name: "index_game_answers_on_viewable_id_and_viewable_type", using: :btree

  create_table "categories", force: true do |t|
    t.text     "wx_js"
    t.text     "re_js"
    t.text     "re_css"
    t.text     "re_html"
    t.text     "meta"
    t.integer  "category_id"
    t.text     "html"
    t.string   "name"
    t.integer  "state"
    t.text     "js"
    t.text     "css"
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.integer  "material_type", default: 0, null: false
  end

  create_table "images", force: true do |t|
    t.string   "title"
    t.integer  "viewable_id"
    t.string   "viewable_type"
    t.integer  "state"
    t.string   "body"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  add_index "images", ["viewable_id", "viewable_type"], name: "index_game_images_on_viewable_id_and_viewable_type", using: :btree

  create_table "materials", force: true do |t|
    t.integer  "state",           default: 0
    t.text     "description"
    t.integer  "category_id"
    t.text     "html"
    t.string   "name"
    t.string   "slug"
    t.string   "wx_appid"
    t.string   "wx_tlimg"
    t.string   "wx_url"
    t.string   "wx_title"
    t.string   "wxdesc"
    t.text     "advertisement"
    t.string   "wx_ln"
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
    t.text     "advertisement_1"
  end

  add_index "materials", ["state"], name: "index_materials_on_state", using: :btree

  create_table "question_answers", force: true do |t|
    t.integer "question_id",              null: false
    t.string  "answer",                   null: false
    t.integer "answer_score", default: 0, null: false
  end

  add_index "question_answers", ["question_id"], name: "index_question_answers_on_question_id", using: :btree

  create_table "questions", force: true do |t|
    t.integer  "material_id"
    t.string   "question_title"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "questions", ["material_id"], name: "index_questions_on_material_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "encrypt_pwd"
    t.string   "salt"
    t.string   "rememberme_token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end

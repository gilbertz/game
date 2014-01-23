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

ActiveRecord::Schema.define(version: 20140122085617) do

  create_table "answers", force: true do |t|
    t.string   "title"
    t.string   "img"
    t.integer  "material_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "answers", ["material_id"], name: "index_answers_on_material_id", using: :btree

  create_table "categories", force: true do |t|
    t.integer  "parent_id"
    t.string   "name"
    t.text     "html"
    t.text     "meta"
    t.text     "js"
    t.text     "css"
    t.text     "re_css"
    t.text     "re_js"
    t.text     "re_html"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "images", force: true do |t|
    t.string   "define"
    t.string   "title"
    t.integer  "material_id"
    t.integer  "state"
    t.string   "body"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "images", ["material_id"], name: "index_images_on_material_id", using: :btree

  create_table "materials", force: true do |t|
    t.integer  "category_id"
    t.string   "wx_appid"
    t.string   "title"
    t.string   "slug"
    t.text     "content"
    t.string   "wx_tlimg"
    t.string   "wx_url"
    t.string   "wx_title"
    t.string   "wx_desc"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "materials", ["category_id"], name: "index_materials_on_category_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "encrypt_pwd"
    t.string   "salt"
    t.string   "rememberme_token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end

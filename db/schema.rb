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

ActiveRecord::Schema.define(version: 20150505113556) do

  create_table "ads", force: true do |t|
    t.string   "title"
    t.text     "desc"
    t.string   "img"
    t.string   "click"
    t.boolean  "on"
    t.date     "start_date"
    t.date     "end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "show_count"
    t.integer  "click_count"
    t.integer  "t"
    t.text     "code"
  end

  create_table "answers", force: true do |t|
    t.text     "title"
    t.integer  "group"
    t.string   "img"
    t.integer  "viewable_id"
    t.string   "viewable_type"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "big_than"
    t.integer  "small_than"
    t.integer  "weight"
    t.text     "desc"
    t.string   "url"
  end

  add_index "answers", ["viewable_id", "viewable_type"], name: "index_game_answers_on_viewable_id_and_viewable_type", using: :btree

  create_table "authentications", force: true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.string   "access_token"
    t.integer  "expires_at"
    t.string   "fid"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "unionid"
    t.string   "appid"
    t.string   "city"
    t.string   "province"
    t.string   "sex"
  end

  add_index "authentications", ["unionid"], name: "index_authentications_on_unionid", using: :btree

  create_table "banners", force: true do |t|
    t.integer  "wait",       default: 1, null: false
    t.string   "image_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "state",      default: 0, null: false
    t.string   "link"
  end

  create_table "bgames", force: true do |t|
    t.integer  "beaconid"
    t.integer  "game_id"
    t.integer  "state"
    t.string   "remark"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "burls", force: true do |t|
    t.string   "url"
    t.integer  "beaconid"
    t.integer  "weight"
    t.integer  "state"
    t.integer  "pv"
    t.integer  "uv"
    t.string   "title"
    t.string   "img"
    t.string   "remark"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "target_id"
    t.string   "target_type"
  end

  create_table "card_options", force: true do |t|
    t.integer  "value"
    t.integer  "store"
    t.string   "title"
    t.string   "img"
    t.string   "wx_cardid"
    t.string   "desc"
    t.integer  "probability"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "card_id"
  end

  add_index "card_options", ["card_id"], name: "index_card_options_on_card_id", using: :btree

  create_table "card_records", force: true do |t|
    t.string   "card_id"
    t.string   "appid"
    t.string   "event"
    t.datetime "event_time"
    t.string   "from_user_name"
    t.string   "is_give_by_friend"
    t.string   "user_card_code"
    t.string   "outer_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "old_user_card_code"
  end

  create_table "cards", force: true do |t|
    t.integer  "beaconid"
    t.string   "shop_id"
    t.string   "appid"
    t.string   "cardid"
    t.string   "title"
    t.string   "sub_title"
    t.text     "desc"
    t.integer  "store"
    t.integer  "tid"
    t.date     "start_date"
    t.date     "end_date"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "state"
    t.string   "wx_authorizer_id"
    t.text     "detail_info"
    t.string   "card_type"
    t.string   "code_type"
    t.integer  "total_quantity"
    t.string   "status"
  end

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
    t.integer  "game_type_id"
    t.boolean  "use_wxjs"
  end

  create_table "checks", force: true do |t|
    t.integer  "beaconid"
    t.integer  "user_id"
    t.integer  "state"
    t.float    "lng"
    t.float    "lat"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "game_id"
  end

  create_table "domains", force: true do |t|
    t.string   "name"
    t.boolean  "active"
    t.integer  "tid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "feedbacks", force: true do |t|
    t.string   "username"
    t.text     "content"
    t.integer  "state",      default: 0, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "flinks", force: true do |t|
    t.integer  "beaconid"
    t.string   "wxid"
    t.string   "wxurl"
    t.integer  "state"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "game_types", force: true do |t|
    t.string   "game_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "type_image"
  end

  create_table "hooks", force: true do |t|
    t.integer  "material_id"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "hooks", ["material_id"], name: "index_hooks_on_material_id", using: :btree
  add_index "hooks", ["url"], name: "index_hooks_on_url", using: :btree

  create_table "ibeacons", force: true do |t|
    t.string   "name"
    t.integer  "user_id"
    t.integer  "state"
    t.string   "remark"
    t.string   "url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "provider"
    t.string   "uid"
    t.integer  "merchant_id"
  end

  add_index "ibeacons", ["uid"], name: "index_ibeacons_on_uid", length: {"uid"=>191}, using: :btree
  add_index "ibeacons", ["url"], name: "index_ibeacons_on_url", length: {"url"=>191}, using: :btree
  add_index "ibeacons", ["user_id"], name: "index_ibeacons_on_user_id", using: :btree

  create_table "images", force: true do |t|
    t.string   "title"
    t.integer  "viewable_id"
    t.string   "viewable_type"
    t.integer  "state"
    t.string   "body"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.string   "photo_name"
    t.string   "photo_path"
    t.integer  "user_id"
  end

  add_index "images", ["user_id"], name: "index_images_on_user_id", using: :btree
  add_index "images", ["viewable_id", "viewable_type"], name: "index_game_images_on_viewable_id_and_viewable_type", using: :btree

  create_table "materials", force: true do |t|
    t.integer  "state",                        default: 0
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
    t.datetime "created_at",                               null: false
    t.datetime "updated_at",                               null: false
    t.text     "advertisement_1"
    t.integer  "is_qq",                        default: 0, null: false
    t.integer  "is_recommend_to_qq",           default: 0, null: false
    t.integer  "redis_pv",           limit: 8, default: 0, null: false
    t.integer  "redis_wx_share_pyq", limit: 8, default: 0, null: false
    t.integer  "user_id",                      default: 1, null: false
    t.string   "url"
    t.string   "docid"
    t.string   "link"
    t.string   "thumb"
    t.string   "share_url"
    t.integer  "rrr"
    t.string   "object_type"
    t.integer  "object_id"
  end

  add_index "materials", ["docid"], name: "index_materials_on_docid", using: :btree
  add_index "materials", ["is_qq"], name: "index_materials_on_is_qq", using: :btree
  add_index "materials", ["is_recommend_to_qq"], name: "index_materials_on_is_recommend_to_qq", using: :btree
  add_index "materials", ["redis_pv"], name: "index_materials_on_redis_pv", using: :btree
  add_index "materials", ["redis_wx_share_pyq"], name: "index_materials_on_redis_wx_share_pyq", using: :btree
  add_index "materials", ["rrr"], name: "index_materials_on_rrr", using: :btree
  add_index "materials", ["state"], name: "index_materials_on_state", using: :btree
  add_index "materials", ["user_id"], name: "index_materials_on_user_id", using: :btree

  create_table "merchants", force: true do |t|
    t.integer  "mch_id"
    t.string   "wxappid"
    t.string   "key"
    t.string   "certificate"
    t.string   "rsa"
    t.string   "rsa_key"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.integer  "state"
    t.integer  "level"
    t.integer  "money"
    t.integer  "user_id"
    t.integer  "beaconid"
  end

  add_index "merchants", ["beaconid"], name: "index_merchants_on_beaconid", using: :btree
  add_index "merchants", ["level"], name: "index_merchants_on_level", using: :btree
  add_index "merchants", ["user_id"], name: "index_merchants_on_user_id", using: :btree

  create_table "question_answers", force: true do |t|
    t.integer "question_id",              null: false
    t.string  "answer",                   null: false
    t.integer "answer_score", default: 0, null: false
    t.string  "answer_img"
    t.integer "answer_jump"
  end

  add_index "question_answers", ["question_id"], name: "index_question_answers_on_question_id", using: :btree

  create_table "questions", force: true do |t|
    t.integer  "material_id"
    t.text     "question_title"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "question_img"
  end

  add_index "questions", ["material_id"], name: "index_questions_on_material_id", using: :btree

  create_table "records", force: true do |t|
    t.integer  "user_id"
    t.integer  "game_id"
    t.integer  "score"
    t.integer  "beaconid"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "remark"
    t.string   "action_name"
    t.integer  "from_user_id"
    t.string   "object_type"
    t.integer  "object_id"
    t.string   "sn"
    t.integer  "allocation"
    t.string   "card_id"
  end

  add_index "records", ["beaconid", "score"], name: "index_records_on_beaconid_and_score", using: :btree
  add_index "records", ["beaconid"], name: "index_records_on_beaconid", using: :btree
  add_index "records", ["from_user_id", "score"], name: "index_records_on_from_user_id_and_score", using: :btree
  add_index "records", ["from_user_id", "user_id"], name: "index_records_on_from_user_id_and_user_id", using: :btree
  add_index "records", ["from_user_id"], name: "index_records_on_from_user_id", using: :btree
  add_index "records", ["game_id", "score"], name: "index_records_on_game_id_and_score", using: :btree
  add_index "records", ["game_id"], name: "index_records_on_game_id", using: :btree
  add_index "records", ["object_type", "object_id"], name: "index_records_on_object_type_and_object_id", using: :btree
  add_index "records", ["score"], name: "index_records_on_score", using: :btree
  add_index "records", ["user_id", "game_id"], name: "index_records_on_user_id_and_game_id", using: :btree
  add_index "records", ["user_id"], name: "index_records_on_user_id", using: :btree

  create_table "redpack_people", force: true do |t|
    t.string  "name"
    t.integer "time_id"
    t.integer "value_id"
    t.integer "redpack_id"
  end

  create_table "redpack_times", force: true do |t|
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer  "frequency"
    t.integer  "min"
    t.integer  "max"
    t.integer  "store"
    t.integer  "state"
    t.integer  "probability"
    t.integer  "redpack_id"
    t.integer  "person_num"
    t.integer  "amount"
  end

  create_table "redpack_values", force: true do |t|
    t.integer "money"
    t.integer "redpack_id"
    t.integer "num"
  end

  create_table "redpacks", force: true do |t|
    t.integer  "beaconid"
    t.integer  "app_id"
    t.integer  "shop_id"
    t.string   "sender_name"
    t.string   "wishing"
    t.string   "action_title"
    t.string   "action_remark"
    t.integer  "min"
    t.integer  "max"
    t.string   "suc_url"
    t.string   "fail_url"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "store"
    t.integer  "state"
    t.integer  "amount"
    t.integer  "probability"
    t.integer  "each_max"
    t.integer  "each_num"
    t.integer  "password"
    t.integer  "virtual_num"
    t.datetime "start_time"
    t.datetime "end_time"
  end

  create_table "scores", force: true do |t|
    t.integer  "user_id"
    t.integer  "beaconid"
    t.integer  "value"
    t.integer  "from_user_id"
    t.string   "remark"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "game_id"
    t.integer  "state"
  end

  create_table "shake_records", force: true do |t|
    t.string   "request_url"
    t.integer  "activityid"
    t.string   "ticket"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "time_amounts", force: true do |t|
    t.datetime "time"
    t.integer  "amount"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "redpack_time_id"
    t.datetime "time_end"
  end

  create_table "user_allocations", force: true do |t|
    t.integer  "user_id"
    t.integer  "allocation"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "num"
  end

  create_table "user_scores", force: true do |t|
    t.integer  "user_id"
    t.integer  "beaconid"
    t.integer  "total_score"
    t.integer  "state"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "name",                   limit: 100
    t.string   "encrypt_pwd"
    t.string   "salt"
    t.string   "rememberme_token"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "role",                               default: 0,  null: false
    t.string   "wx_token"
    t.string   "email",                              default: "", null: false
    t.string   "encrypted_password",                 default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                      default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "desc"
    t.string   "profile_img_url"
    t.integer  "sex"
    t.string   "city"
    t.string   "country"
    t.string   "language"
    t.string   "province"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

  create_table "wcards", force: true do |t|
    t.text     "content"
    t.text     "greet_word"
    t.string   "user_id"
    t.integer  "bid"
    t.string   "music"
    t.string   "cover"
    t.integer  "cid"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "state"
    t.string   "thumb"
    t.string   "url"
    t.string   "title"
  end

  create_table "weixins", force: true do |t|
    t.string   "wxid"
    t.boolean  "active"
    t.integer  "tid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "wshows", force: true do |t|
    t.text     "content"
    t.text     "greet_word"
    t.string   "user_id"
    t.integer  "bid"
    t.string   "music"
    t.string   "cover"
    t.integer  "cid"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "state"
    t.string   "thumb"
    t.string   "url"
    t.string   "title"
  end

  create_table "wx_authorizers", force: true do |t|
    t.string   "authorizer_appid"
    t.string   "component_appid"
    t.string   "qrcode_url"
    t.text     "authorizer_info"
    t.text     "authorization_info"
    t.string   "authorizer_refresh_token"
    t.boolean  "unthorized"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "wx_configs", force: true do |t|
    t.boolean  "wx_ad"
    t.string   "wx_link"
    t.string   "wx_id"
    t.string   "secret"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end

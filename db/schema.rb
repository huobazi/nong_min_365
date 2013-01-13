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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130113124214) do

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.string   "slug"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.integer  "items_count", :default => 0
    t.integer  "sort",        :default => 0
  end

  add_index "categories", ["id"], :name => "index_categories_on_id"
  add_index "categories", ["sort"], :name => "index_categories_on_sort"

  create_table "chinese_regions", :force => true do |t|
    t.string   "code"
    t.string   "name"
    t.integer  "level"
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
    t.integer  "province_items_count", :default => 0
    t.integer  "city_items_count",     :default => 0
    t.integer  "county_items_count",   :default => 0
    t.integer  "town_items_count",     :default => 0
    t.integer  "village_items_count",  :default => 0
  end

  add_index "chinese_regions", ["code"], :name => "index_chinese_regions_on_code"
  add_index "chinese_regions", ["level"], :name => "index_chinese_regions_on_level"

  create_table "items", :force => true do |t|
    t.string   "title"
    t.string   "amount"
    t.integer  "xtype"
    t.string   "province_code"
    t.string   "contact_name"
    t.string   "contact_phone"
    t.string   "contact_qq"
    t.text     "body"
    t.integer  "category_id"
    t.integer  "user_id"
    t.datetime "created_at",                   :null => false
    t.datetime "updated_at",                   :null => false
    t.string   "city_code"
    t.string   "county_code"
    t.string   "town_code"
    t.string   "village_code"
    t.string   "province_name"
    t.string   "city_name"
    t.string   "county_name"
    t.string   "town_name"
    t.string   "village_name"
    t.string   "ip"
    t.integer  "visit_count",   :default => 0
  end

  add_index "items", ["category_id"], :name => "index_items_on_category_id"
  add_index "items", ["city_code"], :name => "index_items_on_city_code"
  add_index "items", ["county_code"], :name => "index_items_on_county_code"
  add_index "items", ["province_code"], :name => "index_items_on_province_code"
  add_index "items", ["town_code"], :name => "index_items_on_town_code"
  add_index "items", ["user_id"], :name => "index_items_on_user_id"
  add_index "items", ["village_code"], :name => "index_items_on_village_code"
  add_index "items", ["xtype"], :name => "index_items_on_xtype"

  create_table "rails_admin_histories", :force => true do |t|
    t.text     "message"
    t.string   "username"
    t.integer  "item"
    t.string   "table"
    t.integer  "month",      :limit => 2
    t.integer  "year",       :limit => 8
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
  end

  add_index "rails_admin_histories", ["item", "table", "month", "year"], :name => "index_rails_admin_histories"

  create_table "settings", :force => true do |t|
    t.string   "var",                      :null => false
    t.text     "value"
    t.integer  "thing_id"
    t.string   "thing_type", :limit => 30
    t.datetime "created_at",               :null => false
    t.datetime "updated_at",               :null => false
  end

  add_index "settings", ["thing_type", "thing_id", "var"], :name => "index_settings_on_thing_type_and_thing_id_and_var", :unique => true

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id"
    t.integer  "taggable_id"
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       :limit => 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string "name"
  end

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "email"
    t.string   "password_digest"
    t.string   "cellphone"
    t.string   "qq"
    t.datetime "created_at",                     :null => false
    t.datetime "updated_at",                     :null => false
    t.string   "remember_token"
    t.integer  "items_count",     :default => 0
  end

  add_index "users", ["id"], :name => "index_users_on_id"
  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"
  add_index "users", ["username"], :name => "index_users_on_username"

end

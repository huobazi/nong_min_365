# -*- encoding : utf-8 -*-
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

ActiveRecord::Schema.define(:version => 20130523084021) do

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

  add_index "chinese_regions", ["code", "level"], :name => "index_chinese_regionse"

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
    t.string   "slug"
    t.integer  "publis_status", :default => 0
    t.string   "source"
    t.integer  "refresh_at",    :default => 0
  end

  add_index "items", ["category_id", "refresh_at", "user_id", "province_code", "city_code", "county_code", "town_code", "village_code", "xtype"], :name => "index_on_items"

  create_table "pictures", :force => true do |t|
    t.string   "image"
    t.integer  "imageable_id"
    t.string   "imageable_type"
    t.datetime "created_at",     :null => false
    t.datetime "updated_at",     :null => false
  end

  add_index "pictures", ["imageable_id", "imageable_type"], :name => "index_pictures_on_imageable_id_and_imageable_type"

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
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
    t.string   "remember_token"
    t.integer  "items_count",            :default => 0
    t.string   "password_reset_token"
    t.datetime "password_reset_sent_at"
  end

  add_index "users", ["id"], :name => "index_users_on_id"
  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"
  add_index "users", ["username"], :name => "index_users_on_username"

end

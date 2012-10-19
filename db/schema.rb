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

ActiveRecord::Schema.define(:version => 20121019062012) do

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.string   "slug"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "categories", ["id"], :name => "index_categories_on_id"

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
    t.string   "xtype"
    t.string   "province_code"
    t.string   "contact_name"
    t.string   "contact_phone"
    t.string   "contact_qq"
    t.text     "body"
    t.string   "password"
    t.integer  "category_id"
    t.integer  "user_id"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
    t.string   "city_code"
    t.string   "county_code"
    t.string   "town_code"
    t.string   "village_code"
  end

  add_index "items", ["category_id"], :name => "index_items_on_category_id"
  add_index "items", ["city_code"], :name => "index_items_on_city_code"
  add_index "items", ["county_code"], :name => "index_items_on_county_code"
  add_index "items", ["province_code"], :name => "index_items_on_province_code"
  add_index "items", ["town_code"], :name => "index_items_on_town_code"
  add_index "items", ["user_id"], :name => "index_items_on_user_id"
  add_index "items", ["village_code"], :name => "index_items_on_village_code"

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

  create_table "users", :force => true do |t|
    t.string   "username"
    t.string   "email"
    t.string   "password_digest"
    t.string   "cellphone"
    t.string   "qq"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
    t.string   "remember_token"
  end

  add_index "users", ["id"], :name => "index_users_on_id"
  add_index "users", ["remember_token"], :name => "index_users_on_remember_token"
  add_index "users", ["username"], :name => "index_users_on_username"

end

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

ActiveRecord::Schema.define(:version => 20141227041343) do

  create_table "categories", :force => true do |t|
    t.string   "name"
    t.string   "slug"
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
    t.integer  "items_count", :default => 0
    t.integer  "sort",        :default => 0
    t.integer  "nid",         :default => 0
    t.integer  "parent_id"
  end

  add_index "categories", ["id"], :name => "index_categories_on_id"
  add_index "categories", ["sort"], :name => "index_categories_on_sort"

  create_table "category_hierarchies", :id => false, :force => true do |t|
    t.integer "ancestor_id",   :null => false
    t.integer "descendant_id", :null => false
    t.integer "generations",   :null => false
  end

  add_index "category_hierarchies", ["ancestor_id", "descendant_id", "generations"], :name => "category_anc_desc_idx", :unique => true
  add_index "category_hierarchies", ["descendant_id"], :name => "category_desc_idx"

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
    t.datetime "created_at",                        :null => false
    t.datetime "updated_at",                        :null => false
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
    t.integer  "visit_count",        :default => 0
    t.string   "slug"
    t.integer  "publis_status",      :default => 0
    t.string   "source"
    t.integer  "refresh_at",         :default => 0
    t.integer  "primary_picture_id"
    t.integer  "category2_id"
  end

  add_index "items", ["category_id", "category2_id", "xtype", "refresh_at", "province_code", "city_code", "county_code", "town_code", "village_code", "user_id"], :name => "index_on_items"

  create_table "pictures", :force => true do |t|
    t.string   "image"
    t.integer  "imageable_id",   :limit => 8
    t.string   "imageable_type"
    t.datetime "created_at",                  :null => false
    t.datetime "updated_at",                  :null => false
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
    t.integer  "taggable_id",   :limit => 8
    t.string   "taggable_type"
    t.integer  "tagger_id"
    t.string   "tagger_type"
    t.string   "context",       :limit => 128
    t.datetime "created_at"
  end

  add_index "taggings", ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], :name => "taggings_idx", :unique => true
  add_index "taggings", ["taggable_id", "taggable_type", "context"], :name => "index_taggings_on_taggable_id_and_taggable_type_and_context"

  create_table "tags", :force => true do |t|
    t.string  "name"
    t.integer "taggings_count", :default => 0
  end

  add_index "tags", ["name"], :name => "index_tags_on_name", :unique => true

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

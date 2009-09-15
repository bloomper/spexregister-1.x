# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090915191107) do

  create_table "actor_items", :force => true do |t|
    t.string   "role",         :limit => 50
    t.string   "vocal",        :limit => 2
    t.integer  "link_item_id",                              :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lock_version",               :default => 0
  end

  add_index "actor_items", ["link_item_id"], :name => "index_actor_items_on_link_item_id"

  create_table "function_category_items", :force => true do |t|
    t.string  "category_name",                    :null => false
    t.boolean "has_actor",     :default => false
  end

  add_index "function_category_items", ["category_name"], :name => "index_function_category_items_on_category_name", :unique => true

  create_table "function_items", :force => true do |t|
    t.string   "name",                      :limit => 50,                :null => false
    t.integer  "function_category_item_id",                              :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lock_version",                            :default => 0
  end

  add_index "function_items", ["name"], :name => "index_function_items_on_name"

  create_table "function_items_link_items", :id => false, :force => true do |t|
    t.integer "function_item_id", :null => false
    t.integer "link_item_id",     :null => false
  end

  create_table "link_items", :force => true do |t|
    t.integer  "spexare_item_id",                :null => false
    t.integer  "spex_item_id",                   :null => false
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lock_version",    :default => 0
  end

  create_table "news_items", :force => true do |t|
    t.string   "publication_date", :limit => 10,                :null => false
    t.string   "subject",          :limit => 85,                :null => false
    t.text     "body",                                          :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lock_version",                   :default => 0
  end

  add_index "news_items", ["publication_date"], :name => "index_news_items_on_publication_date"

  create_table "related_spexare_items", :id => false, :force => true do |t|
    t.integer "spexare_item_id"
    t.integer "related_spexare_item_id"
  end

  create_table "role_items", :force => true do |t|
    t.string   "name",         :limit => 20,                :null => false
    t.string   "description",  :limit => 40,                :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lock_version",               :default => 0
  end

  add_index "role_items", ["description"], :name => "index_role_items_on_description", :unique => true
  add_index "role_items", ["name"], :name => "index_role_items_on_name", :unique => true

  create_table "spex_category_items", :force => true do |t|
    t.string "category_name", :null => false
  end

  add_index "spex_category_items", ["category_name"], :name => "index_spex_category_items_on_category_name", :unique => true

  create_table "spex_items", :force => true do |t|
    t.string   "year",                  :limit => 4,                 :null => false
    t.string   "title",                 :limit => 50,                :null => false
    t.integer  "spex_category_item_id",                              :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lock_version",                        :default => 0
  end

  add_index "spex_items", ["title"], :name => "index_spex_items_on_title"
  add_index "spex_items", ["year"], :name => "index_spex_items_on_year"

  create_table "spex_poster_items", :force => true do |t|
    t.integer "spex_item_id"
    t.string  "content_type"
    t.string  "filename"
    t.integer "size"
    t.integer "parent_id"
    t.string  "thumbnail"
    t.integer "width"
    t.integer "height"
  end

  add_index "spex_poster_items", ["spex_item_id"], :name => "index_spex_poster_items_on_spex_item_id"

  create_table "spexare_items", :force => true do |t|
    t.string   "last_name",         :limit => 40,                    :null => false
    t.string   "first_name",        :limit => 30,                    :null => false
    t.string   "nick_name",         :limit => 30
    t.string   "street_address",    :limit => 75
    t.string   "postal_code",       :limit => 30
    t.string   "postal_address",    :limit => 40
    t.string   "country",           :limit => 30
    t.string   "phone_home",        :limit => 25
    t.string   "phone_work",        :limit => 25
    t.string   "phone_mobile",      :limit => 25
    t.string   "phone_other",       :limit => 25
    t.string   "email_address",     :limit => 50
    t.string   "birth_date",        :limit => 10
    t.string   "social_security",   :limit => 4
    t.boolean  "chalmers_student",                :default => true
    t.string   "graduation",        :limit => 5
    t.string   "comment"
    t.boolean  "deceased",                        :default => false
    t.boolean  "publish_approval",                :default => true
    t.boolean  "want_circulars",                  :default => true
    t.boolean  "fgv_member",                      :default => false
    t.boolean  "alumni_member",                   :default => false
    t.boolean  "uncertain_address",               :default => false
    t.integer  "user_item_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lock_version",                    :default => 0
  end

  add_index "spexare_items", ["user_item_id"], :name => "index_spexare_items_on_user_item_id", :unique => true
  add_index "spexare_items", ["first_name"], :name => "index_spexare_items_on_first_name"
  add_index "spexare_items", ["last_name"], :name => "index_spexare_items_on_last_name"

  create_table "spexare_picture_items", :force => true do |t|
    t.integer "spexare_item_id"
    t.string  "content_type"
    t.string  "filename"
    t.integer "size"
    t.integer "parent_id"
    t.string  "thumbnail"
    t.integer "width"
    t.integer "height"
  end

  add_index "spexare_picture_items", ["spexare_item_id"], :name => "index_spexare_picture_items_on_spexare_item_id"

  create_table "user_items", :force => true do |t|
    t.string   "user_name",          :limit => 20,                    :null => false
    t.string   "user_password",      :limit => 40,                    :null => false
    t.boolean  "temporary_password",               :default => false
    t.boolean  "disabled",                         :default => false
    t.integer  "role_item_id",                                        :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "lock_version",                     :default => 0
  end

  add_index "user_items", ["user_name"], :name => "index_user_items_on_user_name", :unique => true

end

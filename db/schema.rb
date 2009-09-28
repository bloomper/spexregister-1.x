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

ActiveRecord::Schema.define(:version => 20090921205709) do

  create_table "actors", :force => true do |t|
    t.string   "role",         :limit => 50
    t.integer  "vocal_id"
    t.integer  "link_id",                                   :null => false
    t.integer  "lock_version",               :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "actors", ["link_id"], :name => "index_actors_on_link_id"

  create_table "function_categories", :force => true do |t|
    t.string  "name",                         :null => false
    t.boolean "has_actor", :default => false
  end

  add_index "function_categories", ["name"], :name => "index_function_categories_on_name", :unique => true

  create_table "functions", :force => true do |t|
    t.string   "name",                 :limit => 50,                :null => false
    t.integer  "function_category_id",                              :null => false
    t.integer  "lock_version",                       :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "functions", ["name"], :name => "index_functions_on_name"

  create_table "functions_links", :id => false, :force => true do |t|
    t.integer "function_id", :null => false
    t.integer "link_id",     :null => false
  end

  create_table "links", :force => true do |t|
    t.integer  "spexare_id",                  :null => false
    t.integer  "spex_id",                     :null => false
    t.integer  "position"
    t.integer  "lock_version", :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "news", :force => true do |t|
    t.string   "publication_date", :limit => 10,                :null => false
    t.string   "subject",          :limit => 85,                :null => false
    t.text     "body",                                          :null => false
    t.integer  "lock_version",                   :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "news", ["publication_date"], :name => "index_news_on_publication_date"

  create_table "permissions", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "permissions", ["name"], :name => "index_permissions_on_name", :unique => true

  create_table "permissions_user_groups", :id => false, :force => true do |t|
    t.integer "permission_id"
    t.integer "user_group_id"
  end

  create_table "related_spexare", :id => false, :force => true do |t|
    t.integer "spexare_id"
    t.integer "related_spexare_id"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "spex", :force => true do |t|
    t.string   "year",                :limit => 4,                 :null => false
    t.string   "title",               :limit => 50,                :null => false
    t.integer  "spex_category_id",                                 :null => false
    t.string   "poster_file_name"
    t.string   "poster_content_type"
    t.integer  "poster_file_size"
    t.datetime "poster_updated_at"
    t.integer  "lock_version",                      :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "spex", ["year"], :name => "index_spex_on_year"
  add_index "spex", ["title"], :name => "index_spex_on_title"

  create_table "spex_categories", :force => true do |t|
    t.string "name", :null => false
  end

  add_index "spex_categories", ["name"], :name => "index_spex_categories_on_name", :unique => true

  create_table "spexare", :force => true do |t|
    t.string   "last_name",              :limit => 40,                    :null => false
    t.string   "first_name",             :limit => 30,                    :null => false
    t.string   "nick_name",              :limit => 30
    t.string   "street_address",         :limit => 75
    t.string   "postal_code",            :limit => 30
    t.string   "postal_address",         :limit => 40
    t.string   "country",                :limit => 30
    t.string   "phone_home",             :limit => 25
    t.string   "phone_work",             :limit => 25
    t.string   "phone_mobile",           :limit => 25
    t.string   "phone_other",            :limit => 25
    t.string   "email_address",          :limit => 50
    t.string   "birth_date",             :limit => 10
    t.string   "social_security_number", :limit => 4
    t.boolean  "chalmers_student",                     :default => true
    t.string   "graduation",             :limit => 5
    t.string   "comment"
    t.boolean  "deceased",                             :default => false
    t.boolean  "publish_approval",                     :default => true
    t.boolean  "want_circulars",                       :default => true
    t.boolean  "fgv_member",                           :default => false
    t.boolean  "alumni_member",                        :default => false
    t.boolean  "uncertain_address",                    :default => false
    t.integer  "user_id"
    t.string   "picture_file_name"
    t.string   "picture_content_type"
    t.integer  "picture_file_size"
    t.datetime "picture_updated_at"
    t.integer  "lock_version",                         :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "spexare", ["last_name"], :name => "index_spexare_on_last_name"
  add_index "spexare", ["first_name"], :name => "index_spexare_on_first_name"
  add_index "spexare", ["user_id"], :name => "index_spexare_on_user_id", :unique => true

  create_table "user_groups", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_groups", ["name"], :name => "index_user_groups_on_name", :unique => true

  create_table "user_groups_users", :id => false, :force => true do |t|
    t.integer "user_group_id"
    t.integer "user_id"
  end

  create_table "users", :force => true do |t|
    t.string   "username",                          :null => false
    t.string   "crypted_password",                  :null => false
    t.string   "password_salt",                     :null => false
    t.string   "persistence_token",                 :null => false
    t.string   "perishable_token",                  :null => false
    t.integer  "login_count",        :default => 0, :null => false
    t.integer  "failed_login_count", :default => 0, :null => false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string   "current_login_ip"
    t.string   "last_login_ip"
    t.integer  "lock_version",       :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["username"], :name => "index_users_on_username", :unique => true

end

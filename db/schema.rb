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

ActiveRecord::Schema.define(:version => 20110428191858) do

  create_table "activities", :force => true do |t|
    t.integer  "spexare_id",                  :null => false
    t.integer  "lock_version", :default => 0
    t.string   "created_by"
    t.string   "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "activities", ["spexare_id"], :name => "spexare_id"

  create_table "actors", :force => true do |t|
    t.string   "role"
    t.integer  "vocal_id"
    t.integer  "function_activity_id",                :null => false
    t.integer  "lock_version",         :default => 0
    t.string   "created_by"
    t.string   "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "actors", ["function_activity_id"], :name => "index_actors_on_function_activity_id"

  create_table "delayed_jobs", :force => true do |t|
    t.integer  "priority",   :default => 0
    t.integer  "attempts",   :default => 0
    t.text     "handler"
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], :name => "delayed_jobs_priority"

  create_table "function_activities", :force => true do |t|
    t.integer  "function_id",                 :null => false
    t.integer  "activity_id",                 :null => false
    t.integer  "lock_version", :default => 0
    t.string   "created_by"
    t.string   "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "function_activities", ["function_id"], :name => "function_id"
  add_index "function_activities", ["activity_id"], :name => "activity_id"

  create_table "function_categories", :force => true do |t|
    t.string   "name",                            :null => false
    t.boolean  "has_actor",    :default => false
    t.integer  "lock_version", :default => 0
    t.string   "created_by"
    t.string   "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "function_categories", ["name"], :name => "index_function_categories_on_name", :unique => true

  create_table "functions", :force => true do |t|
    t.string   "name",                                :null => false
    t.integer  "function_category_id",                :null => false
    t.integer  "lock_version",         :default => 0
    t.string   "created_by"
    t.string   "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "functions", ["function_category_id"], :name => "function_category_id"
  add_index "functions", ["name"], :name => "index_functions_on_name"

  create_table "memberships", :force => true do |t|
    t.string   "year",         :limit => 4,                :null => false
    t.integer  "kind_id",                                  :null => false
    t.integer  "spexare_id",                               :null => false
    t.integer  "lock_version",              :default => 0
    t.string   "created_by"
    t.string   "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "memberships", ["spexare_id"], :name => "index_memberships_on_spexare_id"

  create_table "news", :force => true do |t|
    t.date     "publication_date",                    :null => false
    t.string   "subject",                             :null => false
    t.text     "body",                                :null => false
    t.text     "cached_body_html"
    t.boolean  "is_published",     :default => false
    t.integer  "lock_version",     :default => 0
    t.string   "created_by"
    t.string   "updated_by"
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

  add_index "permissions_user_groups", ["permission_id"], :name => "permission_id"
  add_index "permissions_user_groups", ["user_group_id"], :name => "user_group_id"

  create_table "queued_mails", :force => true do |t|
    t.text   "object"
    t.string "mailer"
  end

  create_table "relationships", :id => false, :force => true do |t|
    t.integer  "spexare_id", :null => false
    t.integer  "spouse_id",  :null => false
    t.string   "created_by"
    t.string   "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "relationships", ["spexare_id"], :name => "spexare_id"
  add_index "relationships", ["spouse_id"], :name => "spouse_id"

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "settings", :force => true do |t|
    t.string   "var",                       :null => false
    t.text     "value"
    t.integer  "target_id"
    t.string   "target_type", :limit => 30
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "settings", ["target_type", "target_id", "var"], :name => "index_settings_on_target_type_and_target_id_and_var", :unique => true

  create_table "spex", :force => true do |t|
    t.string   "year",             :limit => 4,                :null => false
    t.integer  "spex_category_id",                             :null => false
    t.integer  "lock_version",                  :default => 0
    t.string   "created_by"
    t.string   "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "spex_detail_id",                               :null => false
    t.integer  "parent_id"
    t.integer  "lft"
    t.integer  "rgt"
  end

  add_index "spex", ["spex_category_id"], :name => "spex_category_id"
  add_index "spex", ["year"], :name => "index_spex_on_year"
  add_index "spex", ["spex_detail_id"], :name => "spex_detail_id"

  create_table "spex_activities", :force => true do |t|
    t.integer  "spex_id",                     :null => false
    t.integer  "activity_id",                 :null => false
    t.integer  "lock_version", :default => 0
    t.string   "created_by"
    t.string   "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "spex_activities", ["spex_id"], :name => "spex_id"
  add_index "spex_activities", ["activity_id"], :name => "activity_id"

  create_table "spex_categories", :force => true do |t|
    t.string   "name",                                          :null => false
    t.string   "first_year",        :limit => 4,                :null => false
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
    t.integer  "lock_version",                   :default => 0
    t.string   "created_by"
    t.string   "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "spex_categories", ["name"], :name => "index_spex_categories_on_name", :unique => true

  create_table "spex_details", :force => true do |t|
    t.string   "title",                              :null => false
    t.string   "poster_file_name"
    t.string   "poster_content_type"
    t.integer  "poster_file_size"
    t.datetime "poster_updated_at"
    t.integer  "lock_version",        :default => 0
    t.string   "created_by"
    t.string   "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "spex_details", ["title"], :name => "index_spex_details_on_title"

  create_table "spexare", :force => true do |t|
    t.string   "last_name",                                           :null => false
    t.string   "first_name",                                          :null => false
    t.string   "nick_name"
    t.string   "street_address"
    t.string   "postal_code"
    t.string   "postal_address"
    t.string   "country"
    t.string   "phone_home"
    t.string   "phone_work"
    t.string   "phone_mobile"
    t.string   "phone_other"
    t.string   "email_address"
    t.date     "birth_date"
    t.string   "encrypted_social_security_number"
    t.boolean  "chalmers_student",                 :default => true
    t.string   "graduation"
    t.string   "comment"
    t.boolean  "deceased",                         :default => false
    t.boolean  "publish_approval",                 :default => true
    t.boolean  "want_circulars",                   :default => true
    t.string   "picture_file_name"
    t.string   "picture_content_type"
    t.integer  "picture_file_size"
    t.datetime "picture_updated_at"
    t.integer  "lock_version",                     :default => 0
    t.string   "created_by"
    t.string   "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "want_email_circulars",             :default => false
  end

  add_index "spexare", ["last_name"], :name => "index_spexare_on_last_name"
  add_index "spexare", ["first_name"], :name => "index_spexare_on_first_name"

  create_table "taggings", :force => true do |t|
    t.integer  "tag_id",                      :null => false
    t.integer  "spexare_id",                  :null => false
    t.integer  "lock_version", :default => 0
    t.string   "created_by"
    t.string   "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "taggings", ["tag_id"], :name => "index_taggings_on_tag_id"
  add_index "taggings", ["spexare_id"], :name => "index_taggings_on_spexare_id"

  create_table "tags", :force => true do |t|
    t.string   "name"
    t.integer  "lock_version", :default => 0
    t.string   "created_by"
    t.string   "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tags", ["name"], :name => "index_tags_on_name", :unique => true

  create_table "user_events", :force => true do |t|
    t.string   "session_id"
    t.integer  "user_id"
    t.integer  "kind_id",                     :null => false
    t.integer  "lock_version", :default => 0
    t.string   "created_by"
    t.string   "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_events", ["user_id"], :name => "index_user_events_on_user_id"
  add_index "user_events", ["kind_id"], :name => "index_user_events_on_kind_id"

  create_table "user_groups", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_groups", ["name"], :name => "index_user_groups_on_name", :unique => true

  create_table "user_groups_users", :id => false, :force => true do |t|
    t.integer  "user_group_id"
    t.integer  "user_id"
    t.integer  "lock_version",  :default => 0
    t.string   "created_by"
    t.string   "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "user_groups_users", ["user_group_id"], :name => "user_group_id"
  add_index "user_groups_users", ["user_id"], :name => "user_id"

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
    t.string   "state"
    t.integer  "spexare_id"
    t.integer  "lock_version",       :default => 0
    t.string   "created_by"
    t.string   "updated_by"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["username"], :name => "index_users_on_username", :unique => true
  add_index "users", ["spexare_id"], :name => "index_users_on_spexare_id", :unique => true
  add_index "users", ["perishable_token"], :name => "index_users_on_perishable_token"

  add_foreign_key "activities", ["spexare_id"], "spexare", ["id"], :name => "activities_ibfk_1"

  add_foreign_key "actors", ["function_activity_id"], "function_activities", ["id"], :name => "actors_ibfk_1"

  add_foreign_key "function_activities", ["function_id"], "functions", ["id"], :name => "function_activities_ibfk_1"
  add_foreign_key "function_activities", ["activity_id"], "activities", ["id"], :name => "function_activities_ibfk_2"

  add_foreign_key "functions", ["function_category_id"], "function_categories", ["id"], :name => "functions_ibfk_1"

  add_foreign_key "memberships", ["spexare_id"], "spexare", ["id"], :name => "memberships_ibfk_1"

  add_foreign_key "permissions_user_groups", ["permission_id"], "permissions", ["id"], :name => "permissions_user_groups_ibfk_1"
  add_foreign_key "permissions_user_groups", ["user_group_id"], "user_groups", ["id"], :name => "permissions_user_groups_ibfk_2"

  add_foreign_key "relationships", ["spexare_id"], "spexare", ["id"], :name => "relationships_ibfk_1"
  add_foreign_key "relationships", ["spouse_id"], "spexare", ["id"], :name => "relationships_ibfk_2"

  add_foreign_key "spex", ["spex_category_id"], "spex_categories", ["id"], :name => "spex_ibfk_1"
  add_foreign_key "spex", ["spex_detail_id"], "spex_details", ["id"], :name => "spex_ibfk_2"

  add_foreign_key "spex_activities", ["spex_id"], "spex", ["id"], :name => "spex_activities_ibfk_1"
  add_foreign_key "spex_activities", ["activity_id"], "activities", ["id"], :name => "spex_activities_ibfk_2"

  add_foreign_key "taggings", ["spexare_id"], "spexare", ["id"], :name => "taggings_ibfk_1"
  add_foreign_key "taggings", ["tag_id"], "tags", ["id"], :name => "taggings_ibfk_2"

  add_foreign_key "user_events", ["user_id"], "users", ["id"], :name => "user_events_ibfk_1"

  add_foreign_key "user_groups_users", ["user_group_id"], "user_groups", ["id"], :name => "user_groups_users_ibfk_1"
  add_foreign_key "user_groups_users", ["user_id"], "users", ["id"], :name => "user_groups_users_ibfk_2"

  add_foreign_key "users", ["spexare_id"], "spexare", ["id"], :name => "users_ibfk_1"

end

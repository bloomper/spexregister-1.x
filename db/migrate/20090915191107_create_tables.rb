class CreateTables < ActiveRecord::Migration
  def self.up
    create_table :function_categories, :force => true do |t|
      t.string :name, :null => false
      t.boolean :has_actor, :default => false
      t.timestamps
    end
    add_index :function_categories, :name, :unique => true

    create_table :functions, :force => true do |t|
      t.string :name, :limit => 50, :null => false
      t.integer :function_category_id, :null => false
      t.integer :lock_version, :default => 0
      t.string :created_by
      t.string :updated_by
      t.timestamps
      t.foreign_key :function_category_id, :function_categories, :id
    end
    add_index :functions, :name

    create_table :spex_categories, :force => true do |t|
      t.string :name, :null => false
      t.timestamps
    end
    add_index :spex_categories, :name, :unique => true

    create_table :spex, :force => true do |t|
      t.string :year, :limit => 4, :null => false
      t.string :title, :limit => 50, :null => false
      t.boolean :is_revival, :default => false
      t.integer :spex_category_id, :null => false
      t.string :poster_file_name
      t.string :poster_content_type
      t.integer :poster_file_size
      t.datetime :poster_updated_at
      t.integer :lock_version, :default => 0
      t.string :created_by
      t.string :updated_by
      t.timestamps
      t.foreign_key :spex_category_id, :spex_categories, :id
    end
    add_index :spex, :year
    add_index :spex, :title

    create_table :news, :force => true do |t|
      t.datetime :publication_date, :null => false
      t.string :subject, :limit => 85, :null => false
      t.text :body, :null => false
      t.integer :lock_version, :default => 0
      t.string :created_by
      t.string :updated_by
      t.timestamps
    end
    add_index :news, :publication_date

    create_table :users, :force => true do |t|
      t.string :username, :null => false
      t.string :crypted_password, :null => false
      t.string :password_salt, :null => false
      t.string :persistence_token, :null => false
      t.string :perishable_token, :null => false
      t.integer :login_count, :null => false, :default => 0
      t.integer :failed_login_count, :null => false, :default => 0
      t.datetime :last_request_at
      t.datetime :current_login_at
      t.datetime :last_login_at
      t.string :current_login_ip
      t.string :last_login_ip
      t.string :state
      t.integer :lock_version, :default => 0
      t.string :created_by
      t.string :updated_by
      t.timestamps
    end
    add_index :users, :username, :unique => true
    add_index :users, :perishable_token

    create_table :user_groups, :force => true do |t|
      t.string :name
      t.timestamps
    end
    add_index :user_groups, :name, :unique => true

    create_table :user_groups_users, :force => true, :id => false do |t|
      t.integer :user_group_id
      t.integer :user_id
      t.foreign_key :user_group_id, :user_groups, :id
      t.foreign_key :user_id, :users, :id
    end

    create_table :permissions, :force => true do |t|
      t.string :name
      t.timestamps
    end
    add_index :permissions, :name, :unique => true

		create_table :permissions_user_groups, :id => false do |t|
      t.integer :permission_id
      t.integer :user_group_id
      t.foreign_key :permission_id, :permissions, :id
      t.foreign_key :user_group_id, :user_groups, :id
    end

    create_table :spexare, :force => true do |t|
      t.string :last_name, :limit => 40, :null => false
      t.string :first_name, :limit => 30, :null => false
      t.string :nick_name, :limit => 30
      t.string :street_address, :limit => 75
      t.string :postal_code, :limit => 30
      t.string :postal_address, :limit => 40
      t.string :country, :limit => 100
      t.string :phone_home, :limit => 25
      t.string :phone_work, :limit => 25
      t.string :phone_mobile, :limit => 25
      t.string :phone_other, :limit => 25
      t.string :email_address, :limit => 50
      t.datetime :birth_date
      t.string :encrypted_social_security_number
      t.boolean :chalmers_student, :default => true
      t.string :graduation, :limit => 5
      t.string :comment
      t.boolean :deceased, :default => false
      t.boolean :publish_approval, :default => true
      t.boolean :want_circulars, :default => true
      t.boolean :uncertain_address, :default => false
      t.integer :user_id
      t.string :picture_file_name
      t.string :picture_content_type
      t.integer :picture_file_size
      t.datetime :picture_updated_at
      t.integer :lock_version, :default => 0
      t.string :created_by
      t.string :updated_by
      t.timestamps
      t.foreign_key :user_id, :users, :id
    end
    add_index :spexare, :last_name
    add_index :spexare, :first_name
    add_index :spexare, :user_id, :unique => true

    create_table :cohabitants, :id => false, :force => true do |t|
      t.integer :spexare_id, :null => false
      t.integer :spexare_id_cohabitant, :null => false
      t.foreign_key :spexare_id, :spexare, :id
      t.foreign_key :spexare_id_cohabitant, :spexare, :id
      t.string :created_by
      t.string :updated_by
      t.timestamps
    end

    create_table :memberships, :force => true do |t|
      t.string :year, :limit => 4, :null => false
      t.integer :kind_id, :null => false
      t.integer :spexare_id, :null => false
      t.integer :lock_version, :default => 0
      t.string :created_by
      t.string :updated_by
      t.timestamps
      t.foreign_key :spexare_id, :spexare, :id
    end
    add_index :memberships, :spexare_id

    create_table :activities, :force => true do |t|
      t.integer :spexare_id, :null => false
      t.integer :position
      t.integer :lock_version, :default => 0
      t.string :created_by
      t.string :updated_by
      t.timestamps
      t.foreign_key :spexare_id, :spexare, :id
    end

    create_table :spex_activities, :force => true do |t|
      t.integer :spex_id, :null => false
      t.integer :activity_id, :null => false
      t.foreign_key :spex_id, :spex, :id
      t.foreign_key :activity_id, :activities, :id
    end

    create_table :function_activities, :force => true do |t|
      t.integer :function_id, :null => false
      t.integer :activity_id, :null => false
      t.foreign_key :function_id, :functions, :id
      t.foreign_key :activity_id, :activities, :id
    end

    create_table :actors, :force => true do |t|
      t.string :role, :limit => 50
      t.integer :vocal_id
      t.integer :function_activity_id, :null => false
      t.integer :lock_version, :default => 0
      t.string :created_by
      t.string :updated_by
      t.timestamps
      t.foreign_key :function_activity_id, :function_activities, :id
    end
    add_index :actors, :function_activity_id
  end

  def self.down
    drop_table :actors
    drop_table :function_activities
    drop_table :spex_activities
    drop_table :activities
    drop_table :cohabitants
    drop_table :memberships
    drop_table :spexare
    drop_table :permissions_user_groups
    drop_table :permissions
    drop_table :user_groups_users
    drop_table :user_groups
    drop_table :users
    drop_table :news
    drop_table :spex
    drop_table :spex_categories
    drop_table :functions
    drop_table :function_categories
  end
end

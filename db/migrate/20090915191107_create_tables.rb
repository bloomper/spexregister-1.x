class CreateTables < ActiveRecord::Migration
  def self.up
    create_table :function_categories, :force => true do |t|
      t.column :name, :string, :null => false
      t.column :has_actor, :boolean, :default => false
    end
    add_index :function_categories, :name, :unique => true

    create_table :functions, :force => true do |t|
      t.column :name, :string, :limit => 50, :null => false
      t.column :function_category_id, :integer, :null => false
      t.column :created_at, :timestamp
      t.column :updated_at, :timestamp
      t.column :lock_version, :integer, :default => 0
      t.foreign_key :function_category_id, :function_categories, :id
    end
    add_index :functions, :name

    create_table :spex_categories, :force => true do |t|
      t.column :name, :string, :null => false
    end
    add_index :spex_categories, :name, :unique => true

    create_table :spex, :force => true do |t|
      t.column :year, :string, :limit => 4, :null => false
      t.column :title, :string, :limit => 50, :null => false
      t.column :spex_category_id, :integer, :null => false
      t.column :created_at, :timestamp
      t.column :updated_at, :timestamp
      t.column :lock_version, :integer, :default => 0
      t.foreign_key :spex_category_id, :spex_categories, :id
    end
    add_index :spex, :year
    add_index :spex, :title

    create_table :spex_posters, :force => true do |t|
      t.column :spex_id, :integer
      t.column :poster_file_name, :string
      t.column :poster_content_type, :string
      t.column :poster_file_size, :integer
      t.column :poster_updated_at,:datetime
      t.foreign_key :spex_id, :spex, :id
    end
    add_index :spex_posters, :spex_id

    create_table :news, :force => true do |t|
      t.column :publication_date, :string, :limit => 10, :null => false
      t.column :subject, :string, :limit => 85, :null => false
      t.column :body, :text, :null => false
      t.column :created_at, :timestamp
      t.column :updated_at, :timestamp
      t.column :lock_version, :integer, :default => 0
    end
    add_index :news, :publication_date

    create_table :roles, :force => true do |t|
      t.column :name, :string, :limit => 20, :null => false
      t.column :description, :string, :limit => 40, :null => false
      t.column :created_at, :timestamp
      t.column :updated_at, :timestamp
      t.column :lock_version, :integer, :default => 0
    end
    add_index :roles, :name, :unique => true
    add_index :roles, :description, :unique => true

    create_table :users, :force => true do |t|
      t.column :user_name, :string, :limit => 20, :null => false
      t.column :password, :string, :limit => 40, :null => false
      t.column :temporary_password, :boolean, :default => false
      t.column :disabled, :boolean, :default => false
      t.column :role_id, :integer, :null => false
      t.column :created_at, :timestamp
      t.column :updated_at, :timestamp
      t.column :lock_version, :integer, :default => 0
      t.foreign_key :role_id, :roles, :id
    end
    add_index :users, :user_name, :unique => true

    create_table :spexare, :force => true do |t|
      t.column :last_name, :string, :limit => 40, :null => false
      t.column :first_name, :string, :limit => 30, :null => false
      t.column :nick_name, :string, :limit => 30
      t.column :street_address, :string, :limit => 75
      t.column :postal_code, :string, :limit => 30
      t.column :postal_address, :string, :limit => 40
      t.column :country, :string, :limit => 30
      t.column :phone_home, :string, :limit => 25
      t.column :phone_work, :string, :limit => 25
      t.column :phone_mobile, :string, :limit => 25
      t.column :phone_other, :string, :limit => 25
      t.column :email_address, :string, :limit => 50
      t.column :birth_date, :string, :limit => 10
      t.column :social_security, :string, :limit => 4
      t.column :chalmers_student, :boolean, :default => true
      t.column :graduation, :string, :limit => 5
      t.column :comment, :string
      t.column :deceased, :boolean, :default => false
      t.column :publish_approval, :boolean, :default => true
      t.column :want_circulars, :boolean, :default => true
      t.column :fgv_member, :boolean, :default => false
      t.column :alumni_member, :boolean, :default => false
      t.column :uncertain_address, :boolean, :default => false
      t.column :user_id, :integer
      t.column :created_at, :timestamp
      t.column :updated_at, :timestamp
      t.column :lock_version, :integer, :default => 0
      t.foreign_key :user_id, :users, :id
    end
    add_index :spexare, :last_name
    add_index :spexare, :first_name
    add_index :spexare, :user_id, :unique => true

    create_table :related_spexare, :id => false, :force => true do |t|
      t.column :spexare_id, :integer
      t.column :related_spexare_id, :integer
      t.foreign_key :spexare_id, :spexare, :id
      t.foreign_key :related_spexare_id, :spexare, :id
    end

    create_table :spexare_pictures, :force => true do |t|
      t.column :spexare_id, :integer
      t.column :picture_file_name, :string
      t.column :picture_content_type, :string
      t.column :picture_file_size, :integer
      t.column :picture_updated_at,:datetime
      t.foreign_key :spexare_id, :spexare, :id
    end
    add_index :spexare_pictures, :spexare_id

    create_table :links, :force => true do |t|
      t.column :spexare_id, :integer, :null => false
      t.column :spex_id, :integer, :null => false
      t.column :position, :integer
      t.column :created_at, :timestamp
      t.column :updated_at, :timestamp
      t.column :lock_version, :integer, :default => 0
      t.foreign_key :spexare_id, :spexare, :id
      t.foreign_key :spex_id, :spex, :id
    end

    create_table :functions_links, :id => false, :force => true do |t|
      t.column :function_id, :integer, :null => false
      t.column :link_id, :integer, :null => false
      t.foreign_key :function_id, :functions, :id
      t.foreign_key :link_id, :links, :id
    end

    create_table :actors, :force => true do |t|
      t.column :role, :string, :limit => 50
      t.column :vocal_id, :integer
      t.column :link_id, :integer, :null => false
      t.column :created_at, :timestamp
      t.column :updated_at, :timestamp
      t.column :lock_version, :integer, :default => 0
      t.foreign_key :link_id, :links, :id
    end
    add_index :actors, :link_id
  end

  def self.down
    drop_table :actors
    drop_table :functions_links
    drop_table :links
    drop_table :spexare_pictures
    drop_table :related_spexare
    drop_table :spexare
    drop_table :users
    drop_table :roles
    drop_table :news
    drop_table :spex_posters
    drop_table :spex
    drop_table :spex_categories
    drop_table :functions
    drop_table :function_categories
  end
end

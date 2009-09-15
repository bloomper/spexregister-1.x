class CreateTables < ActiveRecord::Migration
  def self.up
    create_table :function_category_items, :force => true do |t|
      t.column :category_name, :string, :null => false
      t.column :has_actor, :boolean, :default => false
    end
    add_index :function_category_items, :category_name, :unique => true

    create_table :function_items, :force => true do |t|
      t.column :name, :string, :limit => 50, :null => false
      t.column :function_category_item_id, :integer, :null => false
      t.column :created_at, :timestamp
      t.column :updated_at, :timestamp
      t.column :lock_version, :integer, :default => 0
      t.foreign_key :function_category_item_id, :function_category_items, :id
    end
    add_index :function_items, :name

    create_table :spex_category_items, :force => true do |t|
      t.column :category_name, :string, :null => false
    end
    add_index :spex_category_items, :category_name, :unique => true

    create_table :spex_items, :force => true do |t|
      t.column :year, :string, :limit => 4, :null => false
      t.column :title, :string, :limit => 50, :null => false
      t.column :spex_category_item_id, :integer, :null => false
      t.column :created_at, :timestamp
      t.column :updated_at, :timestamp
      t.column :lock_version, :integer, :default => 0
      t.foreign_key :spex_category_item_id, :spex_category_items, :id
    end
    add_index :spex_items, :year
    add_index :spex_items, :title

    create_table :spex_poster_items, :force => true do |t|
      t.column :spex_item_id, :integer
      t.column :content_type, :string
      t.column :filename, :string
      t.column :size, :integer
      t.column :parent_id,  :integer
      t.column :thumbnail, :string
      t.column :width, :integer
      t.column :height, :integer
      t.foreign_key :spex_item_id, :spex_items, :id
    end
    add_index :spex_poster_items, :spex_item_id

    create_table :news_items, :force => true do |t|
      t.column :publication_date, :string, :limit => 10, :null => false
      t.column :subject, :string, :limit => 85, :null => false
      t.column :body, :text, :null => false
      t.column :created_at, :timestamp
      t.column :updated_at, :timestamp
      t.column :lock_version, :integer, :default => 0
    end
    add_index :news_items, :publication_date

    create_table :role_items, :force => true do |t|
      t.column :name, :string, :limit => 20, :null => false
      t.column :description, :string, :limit => 40, :null => false
      t.column :created_at, :timestamp
      t.column :updated_at, :timestamp
      t.column :lock_version, :integer, :default => 0
    end
    add_index :role_items, :name, :unique => true
    add_index :role_items, :description, :unique => true

    create_table :user_items, :force => true do |t|
      t.column :user_name, :string, :limit => 20, :null => false
      t.column :user_password, :string, :limit => 40, :null => false
      t.column :temporary_password, :boolean, :default => false
      t.column :disabled, :boolean, :default => false
      t.column :role_item_id, :integer, :null => false
      t.column :created_at, :timestamp
      t.column :updated_at, :timestamp
      t.column :lock_version, :integer, :default => 0
      t.foreign_key :role_item_id, :role_items, :id
    end
    add_index :user_items, :user_name, :unique => true

    create_table :spexare_items, :force => true do |t|
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
      t.column :user_item_id, :integer
      t.column :created_at, :timestamp
      t.column :updated_at, :timestamp
      t.column :lock_version, :integer, :default => 0
      t.foreign_key :user_item_id, :user_items, :id
    end
    add_index :spexare_items, :last_name
    add_index :spexare_items, :first_name
    add_index :spexare_items, :user_item_id, :unique => true

    create_table :related_spexare_items, :id => false, :force => true do |t|
      t.column :spexare_item_id, :integer
      t.column :related_spexare_item_id, :integer
      t.foreign_key :spexare_item_id, :spexare_items, :id
      t.foreign_key :related_spexare_item_id, :spexare_items, :id
    end

    create_table :spexare_picture_items, :force => true do |t|
      t.column :spexare_item_id, :integer
      t.column :content_type, :string
      t.column :filename, :string
      t.column :size, :integer
      t.column :parent_id,  :integer
      t.column :thumbnail, :string
      t.column :width, :integer
      t.column :height, :integer
      t.foreign_key :spexare_item_id, :spexare_items, :id
    end
    add_index :spexare_picture_items, :spexare_item_id

    create_table :link_items, :force => true do |t|
      t.column :spexare_item_id, :integer, :null => false
      t.column :spex_item_id, :integer, :null => false
      t.column :position, :integer
      t.column :created_at, :timestamp
      t.column :updated_at, :timestamp
      t.column :lock_version, :integer, :default => 0
      t.foreign_key :spexare_item_id, :spexare_items, :id
      t.foreign_key :spex_item_id, :spex_items, :id
    end

    create_table :function_items_link_items, :id => false, :force => true do |t|
      t.column :function_item_id, :integer, :null => false
      t.column :link_item_id, :integer, :null => false
      t.foreign_key :function_item_id, :function_items, :id
      t.foreign_key :link_item_id, :link_items, :id
    end

    create_table :actor_items, :force => true do |t|
      t.column :role, :string, :limit => 50
      t.column :vocal, :string, :limit => 2
      t.column :link_item_id, :integer, :null => false
      t.column :created_at, :timestamp
      t.column :updated_at, :timestamp
      t.column :lock_version, :integer, :default => 0
      t.foreign_key :link_item_id, :link_items, :id
    end
    add_index :actor_items, :link_item_id
  end

  def self.down
    drop_table :actor_items
    drop_table :function_items_link_items
    drop_table :link_items
    drop_table :spexare_picture_items
    drop_table :related_spexare_items
    drop_table :spexare_items
    drop_table :user_items
    drop_table :role_items
    drop_table :news_items
    drop_table :spex_poster_items
    drop_table :spex_items
    drop_table :spex_category_items
    drop_table :function_items
    drop_table :function_category_items
  end
end

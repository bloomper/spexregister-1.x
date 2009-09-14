class CreateTables < ActiveRecord::Migration
  def self.up
    create_table :configuration_items, :force => true do |t|
      t.column :name, :string, :null => false
      t.column :value, :string, :null => false
    end
    add_index :configuration_items, :name, :unique => true
    execute 'ALTER TABLE configuration_items ENGINE = MyISAM'

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
    end
    add_index :function_items, :name
    execute 'ALTER TABLE function_items ADD CONSTRAINT fk_function_items_function_category_items FOREIGN KEY (function_category_item_id) REFERENCES function_category_items(id)'

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
    end
    add_index :spex_items, :year
    add_index :spex_items, :title
    execute 'ALTER TABLE spex_items ADD CONSTRAINT fk_spex_items_spex_category_items FOREIGN KEY (spex_category_item_id) REFERENCES spex_category_items(id)'

    create_table :spex_poster_items, :force => true do |t|
      t.column :spex_item_id, :integer
      t.column :content_type, :string
      t.column :filename, :string
      t.column :size, :integer
      t.column :parent_id,  :integer
      t.column :thumbnail, :string
      t.column :width, :integer
      t.column :height, :integer
    end
    add_index :spex_poster_items, :spex_item_id
    execute 'ALTER TABLE spex_poster_items ADD CONSTRAINT fk_spex_poster_items_spex_items FOREIGN KEY (spex_item_id) REFERENCES spex_items(id)'

    create_table :news_items, :force => true do |t|
      t.column :publication_date, :string, :limit => 10, :null => false
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
    end
    add_index :user_items, :user_name, :unique => true
    execute 'ALTER TABLE user_items ADD CONSTRAINT fk_user_items_role_items FOREIGN KEY (role_item_id) REFERENCES role_items(id)'

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
    end
    add_index :spexare_items, :last_name
    add_index :spexare_items, :first_name
    add_index :spexare_items, :user_item_id, :unique => true
    execute 'ALTER TABLE spexare_items ADD CONSTRAINT fk_spexare_items_users_items FOREIGN KEY (user_item_id) REFERENCES user_items(id)'

    create_table :related_spexare_items, :id => false, :force => true do |t|
      t.column :spexare_item_id, :integer
      t.column :related_spexare_item_id, :integer
    end
    execute 'ALTER TABLE related_spexare_items ADD CONSTRAINT fk_related_spexare_item1 FOREIGN KEY (spexare_item_id) REFERENCES spexare_items(id)'
    execute 'ALTER TABLE related_spexare_items ADD CONSTRAINT fk_related_spexare_item2 FOREIGN KEY (related_spexare_item_id) REFERENCES spexare_items(id)'

    create_table :spexare_picture_items, :force => true do |t|
      t.column :spexare_item_id, :integer
      t.column :content_type, :string
      t.column :filename, :string
      t.column :size, :integer
      t.column :parent_id,  :integer
      t.column :thumbnail, :string
      t.column :width, :integer
      t.column :height, :integer
    end
    add_index :spexare_picture_items, :spexare_item_id
    execute 'ALTER TABLE spexare_picture_items ADD CONSTRAINT fk_spexare_picture_items_spexare_items FOREIGN KEY (spexare_item_id) REFERENCES spexare_items(id)'

    create_table :link_items, :force => true do |t|
      t.column :spexare_item_id, :integer, :null => false
      t.column :spex_item_id, :integer, :null => false
      t.column :position, :integer
      t.column :created_at, :timestamp
      t.column :updated_at, :timestamp
      t.column :lock_version, :integer, :default => 0
    end
    execute 'ALTER TABLE link_items ADD CONSTRAINT fk_link_items_spexare_items FOREIGN KEY (spexare_item_id) REFERENCES spexare_items(id)'
    execute 'ALTER TABLE link_items ADD CONSTRAINT fk_link_items_spex_items FOREIGN KEY (spex_item_id) REFERENCES spex_items(id)'

    create_table :function_items_link_items, :id => false, :force => true do |t|
      t.column :function_item_id, :integer, :null => false
      t.column :link_item_id, :integer, :null => false
    end
    execute 'ALTER TABLE function_items_link_items ADD CONSTRAINT PRIMARY KEY (function_item_id, link_item_id)'
    execute 'ALTER TABLE function_items_link_items ADD CONSTRAINT fk_function_items FOREIGN KEY (function_item_id) REFERENCES function_items(id)'
    execute 'ALTER TABLE function_items_link_items ADD CONSTRAINT fk_link_items FOREIGN KEY (link_item_id) REFERENCES link_items(id)'

    create_table :actor_items, :force => true do |t|
      t.column :role, :string, :limit => 50
      t.column :vocal, :string, :limit => 2
      t.column :link_item_id, :integer, :null => false
      t.column :created_at, :timestamp
      t.column :updated_at, :timestamp
      t.column :lock_version, :integer, :default => 0
    end
    add_index :actor_items, :link_item_id
    execute 'ALTER TABLE actor_items ADD CONSTRAINT fk_actor_items_link_items FOREIGN KEY (link_item_id) REFERENCES link_items(id)'

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
    drop_table :configuration_items
  end
end

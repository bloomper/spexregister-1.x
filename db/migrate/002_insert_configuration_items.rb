class InsertConfigurationItems < ActiveRecord::Migration
  def self.up
    down
    
    ConfigurationItem.create :name => ConfigurationItem::APP_VERSION, :value => '0.0.3'
    ConfigurationItem.create :name => ConfigurationItem::ADMIN_MAIL_ADDRESS, :value => 'register@chalmersspexet.com'
    ConfigurationItem.create :name => ConfigurationItem::DEFAULT_LISTING_PAGE_SIZE, :value => '10'
    ConfigurationItem.create :name => ConfigurationItem::RELATED_SPEXARE_DROPDOWN_LIST_SIZE, :value => '12'
    ConfigurationItem.create :name => ConfigurationItem::SPEXARE_DROPDOWN_LIST_SIZE, :value => '15'
    ConfigurationItem.create :name => ConfigurationItem::PAGINATOR_WINDOW_SIZE, :value => '5'
    ConfigurationItem.create :name => ConfigurationItem::EXPORT_PAGE_SIZE, :value => '25'
  end

  def self.down
    ConfigurationItem.delete_all
  end
end

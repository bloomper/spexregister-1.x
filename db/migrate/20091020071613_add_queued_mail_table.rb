class AddQueuedMailTable < ActiveRecord::Migration
  def self.up
    create_table :queued_mails do |t|
      t.text :object
      t.string :mailer
    end
  end

  def self.down
    drop_table :queued_mails
  end
end

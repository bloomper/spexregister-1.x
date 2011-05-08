class Tag < ActiveRecord::Base
  has_many :taggings, :dependent => :destroy

  def self.tags_count
    Tag.find_by_sql('select tags.name, tags.id, count(taggings.tag_id) as count from taggings left join tags on tags.id = taggings.tag_id group by taggings.tag_id having count(taggings.tag_id) > 0 order by tags.name')
  end

  protected
  validates_presence_of :name
  validates_uniqueness_of :name, :allow_blank => true
  
end

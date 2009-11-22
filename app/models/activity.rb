class Activity < ActiveRecord::Base
  belongs_to :spexare
  has_one :spex_activity
  has_one :spex, :through => :spex_activity
  has_many :function_activities
  has_many :functions, :through => :function_activities
  accepts_nested_attributes_for :spex_activity, :allow_destroy => true, :reject_if => :all_blank
  accepts_nested_attributes_for :function_activities, :allow_destroy => true, :reject_if => :all_blank
  acts_as_list :scope => :spexare_id
  named_scope :by_spex_category, lambda { |spex_category| {
      :joins => 'left join spex_activities on spex_activities.activity_id = activities.id left join spex on spex.id = spex_activities.spex_id left join spex_categories on spex_categories.id = spex.spex_category_id',
      :select => 'activities.*',
      :conditions => [ 'spex_categories.id = ?', spex_category.id ]
    }
  }
  
end

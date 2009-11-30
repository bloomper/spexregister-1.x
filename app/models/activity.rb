class Activity < ActiveRecord::Base
  belongs_to :spexare
  has_one :spex_activity, :dependent => :destroy
  has_one :spex, :through => :spex_activity
  has_many :function_activities, :dependent => :destroy
  has_many :functions, :through => :function_activities
  has_many :actors, :through => :function_activities
  accepts_nested_attributes_for :spex_activity, :allow_destroy => true, :reject_if => lambda { |a| a.values.all?(&:blank?) }
  accepts_nested_attributes_for :function_activities, :allow_destroy => true, :reject_if => lambda { |a| a.values.all?(&:blank?) }
  named_scope :by_spex_category, lambda { |spex_category| {
      :joins => 'left join spex_activities on spex_activities.activity_id = activities.id left join spex on spex.id = spex_activities.spex_id left join spex_categories on spex_categories.id = spex.spex_category_id',
      :select => 'activities.*',
      :conditions => [ 'spex_categories.id = ?', spex_category.id ]
    }
  }
  named_scope :by_spex_year, :order => 'spex.year asc', :select => 'activities.*', :joins => 'left join spex_activities on spex_activities.activity_id = activities.id left join spex on spex.id = spex_activities.spex_id'
  named_scope :by_spex_year_desc, :order => 'spex.year desc', :select => 'activities.*', :joins => 'left join spex_activities on spex_activities.activity_id = activities.id left join spex on spex.id = spex_activities.spex_id' 

  def initialize(attributes=nil)
    super
    self.build_spex_activity unless self.spex_activity
  end

end

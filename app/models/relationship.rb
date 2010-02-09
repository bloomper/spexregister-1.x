class Relationship < ActiveRecord::Base
  belongs_to :spexare, :touch => true
  belongs_to :spouse, :class_name => 'Spexare'

  after_create :create_other_side  
  after_destroy :delete_both_sides 

  protected
  def create_other_side
    Relationship.skip_callback(:create_other_side) do
      Relationship.create(:spexare => spouse, :spouse => spexare)
    end
  end
  
  def delete_both_sides
    Relationship.delete_all(['spexare_id = ? OR spouse_id = ?', spexare_id, spexare_id])
  end

  validates_presence_of :spexare
  validates_presence_of :spouse
  
end

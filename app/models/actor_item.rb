class ActorItem < ActiveRecord::Base
  VOCAL_TYPES = [
    ['Okänt', 'NA'],
    ['B1', 'B1'],
    ['B2', 'B2'],
    ['T1', 'T1'],
    ['T2', 'T2']
  ]
  belongs_to :link_item
  
  def self.get_vocal_description(key)
    VOCAL_TYPES.each do |vocal|
      if vocal[1].eql?(key)
        return vocal[0]
      end
    end
  end
  
  protected
    validates_inclusion_of :vocal, :in => VOCAL_TYPES.map {|disp, value| value}, :message => "'%{fn}' måste vara ett av följande värden: 'B1', 'B2', 'T1', 'T2' eller 'Okänt'."
end

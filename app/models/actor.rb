class Actor < ActiveRecord::Base
  VOCAL_TYPES = [
    ['Okänt', 'NA'],
    ['B1', 'B1'],
    ['B2', 'B2'],
    ['T1', 'T1'],
    ['T2', 'T2']
  ]
  belongs_to :link
  
end

class SpexPoster < ActiveRecord::Base
  belongs_to :spex
  has_attachment :processor => :mini_magick, :storage => :file_system, :path_prefix => 'public/assets/spex_posters', :size => 0..150.kilobytes, :content_type => :image, :thumbnails => { :thumb => [50, 70] }

end

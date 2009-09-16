class SpexarePicture < ActiveRecord::Base
  belongs_to :spexare
  has_attachment :processor => :mini_magick, :storage => :file_system, :path_prefix => 'public/assets/spexare_pictures', :size => 0..150.kilobytes, :content_type => :image, :thumbnails => { :thumb => [50, 70] }

end

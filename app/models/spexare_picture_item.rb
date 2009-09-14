class SpexarePictureItem < ActiveRecord::Base
  belongs_to :spexare_item
  has_attachment :processor => :mini_magick, :storage => :file_system, :path_prefix => 'public/assets/spexare_picture_items', :size => 0..150.kilobytes, :content_type => :image, :thumbnails => { :thumb => [50, 70] }

end

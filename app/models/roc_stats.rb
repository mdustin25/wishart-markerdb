class RocStats < ActiveRecord::Base

  # To attach a image image to a model you can do:
  #
  #   absolute_path_to_file = '/Users/mike/Downloads/cat_PNG100.png'
  #   k.image = open(absolute_path_to_file)
  #   k.save
  #
  has_attached_file :image,
    :styles => { :medium => "300x300>", :thumb => "" },
    convert_options: {thumb: "-transparent white -threshold 100% -crop 670x670+70-42  +repage -resize 150x150"},
    :default_url => "/images/:style/missing.png"
  validates_attachment_content_type :image,
    :content_type => ["image/jpg", "image/jpeg", "image/png", "image/gif"]

end

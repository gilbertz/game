class Picture < ActiveRecord::Base
  # belongs_to :store
  belongs_to :owner, polymorphic: true
  #todo 需要重构，store_dir需要根据图片用途指定
  mount_uploader :file_name, PictureUploader
end
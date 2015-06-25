# encoding: utf-8
require "digest/md5"
require 'carrierwave/processing/mini_magick'

class PictureUploader < CarrierWave::Uploader::Base
  include CarrierWave::MiniMagick

  storage :qiniu
  self.qiniu_protocal = 'http'
  self.qiniu_can_overwrite = true

  # Override the directory where uploaded files will be stored.
  def store_dir
    "uploads/item_cover"
  end

  # Add a white list of extensions which are allowed to be uploaded.
  def extension_white_list
    %w(jpg jpeg png)
  end

  def filename
    if original_filename
      @name ||= Digest::MD5.hexdigest(current_path)
      "#{@name}#{File.extname(original_filename).downcase}"
    end
  end

end
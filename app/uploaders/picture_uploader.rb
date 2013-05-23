# -*- encoding : utf-8 -*-

class PictureUploader < CarrierWave::Uploader::Base
  # Choose what kind of storage to use for this uploader:
  storage :qiniu
  self.qiniu_access_key    = SiteSettings.qiniu_access_key
  self.qiniu_secret_key    = SiteSettings.qiniu_secret_key
  self.qiniu_bucket        = "nongmin365"
  self.qiniu_bucket_domain = "nongmin365.qiniudn.com"

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  #
  # This works for the file storage as well as Amazon S3 and Rackspace Cloud Files.
  # Define store_dir as nil if you'd like to store files at the root level.
  # Do not change the store_dir
  def store_dir
    nil
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
   def extension_white_list
     %w(jpg jpeg gif png)
   end

  # Do not change the filename
   def filename
     # 不能出现model.id,因为保存图片时model.id未必生成
     "uploads/#{model.imageable.class.to_s.pluralize.underscore}/#{model.imageable.id}/pictures/#{secure_token(10)}.#{file.extension.downcase}" if original_filename.present?
   end

   protected
   def secure_token(length=16)
     var = :"@#{mounted_as}_secure_token"
     model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.hex(length/2))
   end
end

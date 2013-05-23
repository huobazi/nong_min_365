# -*- encoding : utf-8 -*-

class ItemPictureUploader < CarrierWave::Uploader::Base
  # Choose what kind of storage to use for this uploader:
  storage :qiniu
  self.qiniu_access_key    = SiteSettings.qiniu_access_key
  self.qiniu_secret_key    = SiteSettings.qiniu_secret_key
  self.qiniu_bucket        = "avatars"
  self.qiniu_bucket_domain = "avatars.files.example.com"
  self.qiniu_bucket_domain = "carrierwave-qiniu-example.aspxboy.com"

  # Override the directory where uploaded files will be stored.
  # This is a sensible default for uploaders that are meant to be mounted:
  def store_dir
    "uploads/item/pictures/#{model.id}"
  end

  # Add a white list of extensions which are allowed to be uploaded.
  # For images you might use something like this:
   def extension_white_list
     %w(jpg jpeg gif png)
   end

   # end
   def filename
     "#{secure_token(10)}.#{file.extension}" if original_filename.present?
   end

   protected
   def secure_token(length=16)
     var = :"@#{mounted_as}_secure_token"
     model.instance_variable_get(var) or model.instance_variable_set(var, SecureRandom.hex(length/2))
   end
end

class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick

  def store_dir
    @site = Site.current
    @site ||= model.site
    "uploads/#{@site.slug}/pages/#{model.page.id}/images/"
  end

  def cache_dir
    "#{Rails.root}/tmp/uploads"
  end

  version :thumb do
    process :resize_to_limit => [100, 100]
  end

  def extension_white_list
    %w(jpg gif png)
  end

end

class TeamLogoUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick

  def store_dir
    @site = Site.current
    @site ||= model.site
    "uploads/#{@site.slug}/league/team_logos/"
  end

  def cache_dir
    "#{Rails.root}/tmp/uploads"
  end

  process :resize_to_limit => [400,400]

  version :micro_thumb do
    process :resize_to_limit => [25, 25]
  end

  version :tiny_thumb do
    process :resize_to_limit => [50, 50]
  end

  version :thumb do
    process :resize_to_limit => [100, 100]
  end

  def extension_white_list
    %w(jpg jpeg gif png)
  end

end

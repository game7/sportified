class TeamLogoUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick

  def extension_white_list
    %w(jpg jpeg gif png)
  end

  def store_dir
    @site = Site.current
    @site ||= model.site
    "uploads/#{@site.slug}/league/team_logos/"
  end

  def cache_dir
    "#{Rails.root}/tmp/uploads"
  end

  process :resize_to_limit => [400,400]

  version :small do
    process :crop_and_scale => 200
  end

  version :thumb do
    process :crop_and_scale => 100
  end

  version :tiny do
    process :crop_and_scale => 50
  end

  version :micro do
    process :crop_and_scale => 25
  end
  
  def crop_and_scale(resize_to = nil)
    if model.cropping?
      manipulate! do |img|
        img = img.crop(model.crop_x.to_i, model.crop_y.to_i, model.crop_h.to_i, model.crop_w.to_i)
        img = img.resize(resize_to, resize_to) if resize_to
      end
    else
      resize_to_limit(resize_to, resize_to)
    end
  end


end

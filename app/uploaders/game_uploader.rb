class GameUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick

  def extension_white_list
    %w(csv)
  end

  def store_dir
    @tenant = Tenant.current
    @tenant ||= model.tenant
    "assets/#{@tenant.slug}/#{model.class.to_s.underscore}/#{mounted_as}/#{model.id}"
  end

  def cache_dir
    "#{Rails.root}/tmp/uploads"
  end


end

class ImageUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick

  def store_dir
    tenant = model.tenant || Tenant.current
    if model.respond_to?('page')
      klass = "pages"
      id = model.page.id
    else
      klass = model.class.name.pluralize.downcase
      id = model.id
    end
    "assets/#{tenant.id}/#{klass}/#{id}/images/"
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

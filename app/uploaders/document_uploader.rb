class DocumentUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick

  def store_dir
    tenant = Tenant.current || model.tenant
    "uploads/#{tenant.slug}/pages/#{model.page.id}/documents/"
  end

  def cache_dir
    "#{Rails.root}/tmp/uploads"
  end

  def extension_white_list
    %w(pdf xls doc csv)
  end

end

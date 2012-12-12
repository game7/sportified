class DocumentUploader < CarrierWave::Uploader::Base
  include CarrierWave::RMagick

  def store_dir
    tenant = Tenant.current || model.tenant
    if model.respond_to?('page')
      klass = "pages"
      id = model.page.id
    else
      klass = model.class.name.pluralize.downcase
      id = model.id
    end
    "uploads/#{tenant.slug}/#{klass}/#{id}/documents/"
  end

  def cache_dir
    "#{Rails.root}/tmp/uploads"
  end

  def extension_white_list
    %w(pdf xls doc csv)
  end

end

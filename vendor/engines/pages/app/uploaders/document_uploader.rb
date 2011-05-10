class DocumentUploader < CarrierWave::Uploader::Base

  def store_dir
    @site = Site.current
    @site ||= model.site
    "uploads/#{@site.slug}/documents/"
  end

  def cache_dir
    "#{Rails.root}/tmp/uploads"
  end

  #def extension_white_list
  #  %w(txt doc pdf)
  #end

end

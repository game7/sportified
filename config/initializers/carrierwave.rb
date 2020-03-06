require 'fog/aws'

if Rails.env.test?
  CarrierWave.configure do |config|
    config.root = Rails.root
    config.storage = :file
    config.enable_processing = false
  end
end

# if Rails.env.development?
#   CarrierWave.configure do |config|
#     config.root = "#{Rails.root}/public"
#     config.storage = :file
#     config.enable_processing = true
#   end
# end

if Rails.env.development? || Rails.env.preview?
  CarrierWave.configure do |config|
    config.fog_provider = 'fog/aws'
    config.fog_credentials = {
      :provider               => 'AWS',
      :aws_access_key_id      => Rails.application.credentials.s3[:key],
      :aws_secret_access_key  => Rails.application.credentials.s3[:secret]
    }
    config.fog_directory = Rails.application.credentials.s3[:development][:bucket]
    config.storage = :fog    
  end
end

if Rails.env.production?
  CarrierWave.configure do |config|
    config.fog_provider = 'fog/aws'
    config.fog_credentials = {
      :provider               => 'AWS',
      :aws_access_key_id      => Rails.application.credentials.s3[:key],
      :aws_secret_access_key  => Rails.application.credentials.s3[:secret]
    }
    config.fog_directory = Rails.application.credentials.s3[:development][:bucket]
    config.storage = :fog    
  end
end

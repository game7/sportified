#require 'carrierwave/orm/mongoid'

if Rails.env.test?  
  CarrierWave.configure do |config|
    config.root = Rails.root
    config.storage = :file  
    config.enable_processing = false  
  end  
end  

if Rails.env.development?  
  CarrierWave.configure do |config| 
    config.root = Rails.root 
    config.storage = :file  
    config.enable_processing = true  
  end  
end 

if Rails.env.production?  
  CarrierWave.configure do |config|  
    config.storage = :fog 
    config.fog_credentials = {
      :provider               => 'AWS',
      :aws_access_key_id      => ENV['S3_KEY'],
      :aws_secret_access_key  => ENV['S3_SECRET']
    }
    config.fog_directory = ENV['S3_BUCKET']   
  end  
end 

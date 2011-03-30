#require 'carrierwave/orm/mongoid'
#
#CarrierWave.configure do |config|
#  config.storage              = :s3  
#  config.s3_access_key_id     = s3_config['access_key_id']  
#  config.s3_secret_access_key = s3_config['secret_access_key']  
#  config.s3_bucket            = s3_config['bucket']  
#end
#
if Rails.env.test?  
 CarrierWave.configure do |config|  
   config.storage = :file  
   config.enable_processing = false  
 end  
end  

if Rails.env.development?  
 CarrierWave.configure do |config|  
   config.storage = :file  
   config.enable_processing = true  
 end  
end 

if Rails.env.production?  
 CarrierWave.configure do |config|  
   config.storage = :s3  
 end  
end 

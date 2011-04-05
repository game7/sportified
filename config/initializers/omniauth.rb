Rails.application.config.middleware.use OmniAuth::Builder do  
  # provider :twitter, 'CONSUMER_KEY', 'CONSUMER_SECRET'
  # TODO: move these to environment setting  
  provider :facebook, '109262979133564', '258cba5e2120cde7bc3818ea186e1263' 
  # provider :linked_in, 'CONSUMER_KEY', 'CONSUMER_SECRET'  
end 

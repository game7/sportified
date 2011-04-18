# monkey patch to overcome SSL issue with facebook auth in dev env
# http://stackoverflow.com/questions/3977303/omniauth-facebook-certificate-verify-failed
require 'faraday'
module Faraday 
  class Adapter < Middleware
    def call(env)
      if !env[:body] and Connection::METHODS_WITH_BODIES.include? env[:method]
        # play nice and indicate we're sending an empty body
        env[:request_headers][CONTENT_LENGTH] = "0"
        # Typhoeus hangs on PUT requests if body is nil
        env[:body] = ''
      end      
      env[:ssl][:verify] = false if env[:ssl]
    end
  end
end

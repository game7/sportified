class Layouts::Application::FooterComponent < ViewComponent::Base
  def initialize(tenant:)
    @tenant = tenant
  end

  def address
    helpers.simple_format(@tenant.address)
  end

  def twitter_url
    concat_if @tenant.twitter_id, 'https://twitter.com/'
  end

  def facebook_url
    concat_if @tenant.facebook_id, 'https://www.facebook.com/'
  end

  def google_plus_url
    concat_if @tenant.google_plus_id, 'https://plus.google.com/+'
  end

  def instagram_url
    concat_if @tenant.instagram_id, 'http://instagram.com/'
  end

  def foursquare_url
    concat_if @tenant.foursquare_id, 'https://foursquare.com/v/'
  end   
  
  def social_link
    Layouts::Application::Footer::SocialLinkComponent
  end

  private

    def concat_if(value, target)
      value.present? ? target + value : nil
    end

end

require "test_helper"
require "minitest/autorun"

class Layouts::Application::FooterComponentTest < ViewComponent::TestCase

  test 'should render' do
    render_inline Layouts::Application::FooterComponent.new(tenant: Tenant.new)
    assert rendered_component  
  end

  test 'should return a twitter url' do
    assert_return_url 'twitter', 'https://twitter.com/'
  end     

  test 'should return no twitter_url when no twitter_id' do
    assert_nil_url 'twitter'
  end

  test 'should return a facebook url' do
    assert_return_url 'facebook', 'https://www.facebook.com/'
  end     

  test 'should return no facebook url when no id' do
    assert_nil_url 'facebook'
  end  

  private

    def assert_return_url(service, format)
      id = (service + '_id').to_sym
      handle = service + '-user'
      component = Layouts::Application::FooterComponent.new(tenant: Tenant.new(id => handle))
      assert_equal "#{format}#{handle}", component.send(service + '_url')   
    end

    def assert_nil_url(service)
      id = (service + '_id').to_sym
      handle = service + '-user'
      component = Layouts::Application::FooterComponent.new(tenant: Tenant.new())
      assert_nil component.send(service + '_url')  
    end

end

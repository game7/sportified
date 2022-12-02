module Next::Base::Inertia
  extend ActiveSupport::Concern

  included do
    # bypass CSRF protections specifically for inertia XHR requests
    # https://github.com/inertiajs/inertia-rails/pull/72#issuecomment-941298861
    skip_before_action :verify_authenticity_token, if: -> { request.inertia? }

    # expose current user to all inertia payloads
    inertia_share current_user: -> { current_user }
    inertia_share flash: -> { flash.discard.to_hash }
  end

  # helper method to automatically provide page path/name based on controller/action
  def inertia(props: {})
    page = [params[:controller], params[:action]].join('/')
    render inertia: page, props: props
  end
end

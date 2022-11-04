module Application
  module Authorization
    extend ActiveSupport::Concern

    include Pundit::Authorization

    included do
      rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
    end

    def user_not_authorized(exception)
      policy_name = exception.policy.class.to_s.underscore
      flash[:error] = t "#{policy_name.gsub('/', '.')}.#{exception.query}", scope: 'pundit', default: :default
      redirect_back(fallback_location: root_path)
    end

  end
end
module Typescript::Routes::Generator::Actions
  extend ActiveSupport::Concern

  def build_controllers
    out = []
    out << '// route helpers keyed by controller.action'
    out << 'export const actions = {'
    routes_by_controller.each do |controller, routes|
      next if controller.blank?

      out << "  '#{controller}': {"
      out.concat(build_actions(routes))
      out << '  },'
    end
    out << '}'
  end

  def action_allowed_verbs
    %w[get put patch post delete path]
  end

  def build_actions(routes) # rubocop:disable Metrics/AbcSize
    out = []
    routes.group_by { |route| route[:action] }.each do |action, group|
      route = group[0]
      verbs = (route[:verb].split('|').map(&:downcase).push('path') & action_allowed_verbs)
      out << "    '#{action}': {"
      out.concat(verbs.map { |verb| "      '#{verb}': handle.#{verb}('#{route[:path]}')," })
      out << '    },'
    end
    out
  end
end

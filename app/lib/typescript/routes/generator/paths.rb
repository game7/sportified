module Typescript::Routes::Generator::Paths
  extend ActiveSupport::Concern

  def build_paths
    out = []
    out << '// route helpers keyed by the URL path'
    out << 'export const paths = {'
    out.concat(routes_by_path.map { |path, verbs| build_path(path, verbs) })
    out << '}'
  end

  def allowed_verbs
    %w[get put patch post destroy path]
  end

  def build_path(path, verbs)
    verbs = (verbs.map { |v| v.split('|') }.flatten.map(&:downcase).uniq.push('path') & allowed_verbs)
    out = []
    out << "  '#{path}': {"
    out.concat(verbs.map { |verb| "    #{verb}: handle.#{verb}('#{path}')," })
    out << '  },'
  end
end

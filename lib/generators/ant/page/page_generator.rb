module Ant
  module Generators
    class Ant::PageGenerator < Rails::Generators::NamedBase
      source_root File.expand_path('templates', __dir__)

      def create_page
        template 'page.tsx', File.join('app/javascript/pages', class_path, "#{file_name}.page.tsx")
      end

      private

      def page_component_name
        model_resource_name.camelize
      end

      # plural for index routes, otherwise singular
      def model_property_name
        parts = model_resource_name.split('_')
        name = parts[-2]
        parts[-1] == 'index' ? name : name.singularize
      end

      # array for index routes, otherwise the model type
      def model_type_name
        parts = model_resource_name.split('_')
        name = parts.slice(0, parts.length - 1).map(&:capitalize).join('.').singularize
        parts[-1] == 'index' ? "#{name}[]" : name
      end

      def breadcrumbs
        crumbs = model_resource_name.split('_')
        crumbs.flat_map.with_index do |part, i|
          case part
          when 'index' then next
          when 'show'  then show_breadcrumb(crumbs, i)
          when 'news' then new_breadcrumb(crumbs, i) # for some reason rails is pluralizing "new"
          when 'edit' then [show_breadcrumb(crumbs, i), edit_breadcrumb(crumbs, i)]
          else basic_breadcrumb(crumbs, part, i)
          end
        end.compact.join(',')
      end

      def show_breadcrumb(crumbs, index)
        [
          "{ label: #{crumbs[index - 1].singularize}.id.toString(), ",
          "href: actions[\"#{crumbs[0,
                                    index].join('/')}\"]['show'].path({ id: #{crumbs[index - 1].singularize}.id }) }"
        ].join
      end

      def edit_breadcrumb(crumbs, index)
        [
          '{ label: "Edit", ',
          "href: actions[\"#{crumbs[0,
                                    index].join('/')}\"]['edit'].path({ id: #{crumbs[index - 1].singularize}.id }) }"
        ].join
      end

      def new_breadcrumb(crumbs, index)
        [
          "{ label: \"New #{model_property_name.capitalize}\", ",
          "href: actions[\"#{crumbs[0,
                                    index].join('/')}\"]['new'].path({}) }"
        ].join
      end

      def basic_breadcrumb(crumbs, part, index)
        "{ label: \"#{part.titleize}\", href: actions[\"#{crumbs[0, index + 1].join('/')}\"]['index'].path({}) }"
      end
    end
  end
end

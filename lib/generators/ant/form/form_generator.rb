module Ant
  module Generators
    class Ant::FormGenerator < Rails::Generators::NamedBase
      source_root File.expand_path('templates', __dir__)

      def create_form
        template 'form.tsx', File.join('app/javascript/pages', class_path, "#{file_name}.component.tsx")
      end

      private

      def form_component_name
        model_resource_name.camelize
      end

      def model_property_name
        model_resource_name.split('_')[-2].try(:singularize)
      end

      def model_type_name
        parts = model_resource_name.split('_')
        parts.slice(0, parts.length - 1).map(&:capitalize).join('.').singularize
      end

      def resource_path
        model_resource_name.split('_').tap(&:pop).join('/')
      end
    end
  end
end

module Typescript::Models::Generator::Projections
  extend ActiveSupport::Concern

  def projections
    Projection.descendants.sort_by(&:name)
  end

  def generate_projections
    projections.collect do |projection|
      {
        name: model_name(projection),
        properties: build_attributes(projection)
      }
    end
  end

  def build_attributes(projection)
    return [] unless projection.respond_to?(:attribute_names)

    projection.attribute_names.collect do |name|
      {
        name: name,
        ts_type: convert_attribute(projection.attribute_types[name])
      }
    end
  end

  def convert_attribute(attribute_type)
    attribute_conversions[attribute_type.class.to_s] || 'uknown'
  end

  def attribute_conversions
    {
      'ActiveModel::Type::DateTime' => 'string',
      'ActiveModel::Type::Decimal' => 'number',
      'ActiveModel::Type::Integer' => 'number',
      'ActiveModel::Type::String' => 'string',
      'ActiveModel::Type::Boolean' => 'boolean',
      'ActiveRecord::AttributeMethods::TimeZoneConversion::TimeZoneConverter' => 'string',
      'ActiveModel::Type::Float' => 'number',
      'ActiveRecord::Type::Text' => 'string',
      'ActsAsTaggableOn::Taggable::TagListType' => 'string',
      'ActiveRecord::ConnectionAdapters::PostgreSQL::OID::Hstore' => 'Record<string, unknown>',
      'ActiveRecord::ConnectionAdapters::PostgreSQL::OID::Decimal' => 'number',
      'ActiveRecord::ConnectionAdapters::PostgreSQL::OID::Date' => 'string'
    }
  end
end

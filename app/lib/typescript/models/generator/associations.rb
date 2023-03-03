module Typescript::Models::Generator::Associations
  extend ActiveSupport::Concern

  # build all associations
  def build_associations(model)
    build_attachments(model) + build_has_many(model) + build_has_one(model) + build_belongs_to(model)
  end

  # extract metadata for all has_many associations
  def build_has_many(model)
    model.reflect_on_all_associations.select(&:collection?).map do |collection|
      {
        name: "#{collection.name}?",
        ts_type: "#{model_name(collection.compute_class(collection.class_name))}[]"
      }
    end
  end

  def build_attachments(model)
    model.reflect_on_all_attachments.map do |attachment|
      {
        name: "#{attachment.name}?",
        ts_type: if attachment.class.name.demodulize == 'HasOneAttachedReflection'
                   'ActiveStorage.Attached.One'
                 else
                   'ActiveStorage.Attached.Many'
                 end
      }
    end
  end

  # extract metadata for all has_one associations
  def build_has_one(model)
    model.reflect_on_all_associations.select(&:has_one?).map do |collection|
      {
        name: "#{collection.name}?",
        ts_type: model_name(collection.compute_class(collection.class_name))

      }
    end
  end

  # extract metadata for all belongs_to associations
  def build_belongs_to(model)
    model.reflect_on_all_associations.select(&:belongs_to?).reject(&:polymorphic?).map do |collection|
      {
        name: "#{collection.name}?",
        ts_type: model_name(collection.compute_class(collection.class_name))
      }
    end
  end
end

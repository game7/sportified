# extend models
Rails.configuration.to_prepare do
  module ActsAsTaggableOnTagExtensions # rubocop:disable Lint/ConstantDefinitionInBlock
    extend ActiveSupport::Concern

    included do
      scope :for_tenant, lambda { |tenant|
        ids = ActiveRecord::Base.connection.execute(%(
            SELECT tag_id
            FROM "taggings"
            JOIN "events" ON "taggings"."taggable_id" = "events"."id"
            WHERE "taggings"."taggable_type" = \'Event\'
            AND "events"."tenant_id" = #{tenant.id} GROUP BY "tag_id").squish).pluck('tag_id')
        where(id: ids).order(name: :asc)
      }
    end
  end

  ActsAsTaggableOn::Tag.prepend ActsAsTaggableOnTagExtensions
end

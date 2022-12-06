# == Schema Information
#
# Table name: tags
#
#  id             :integer          not null, primary key
#  color          :string
#  name           :string
#  taggings_count :integer          default(0)
#
# Indexes
#
#  index_tags_on_name  (name) UNIQUE
#
module ActsAsTaggableOn
  class Tag < ActiveRecord::Base
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

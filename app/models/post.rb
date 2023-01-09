# == Schema Information
#
# Table name: posts
#
#  id         :integer          not null, primary key
#  body       :text
#  image      :string
#  link_url   :string
#  summary    :text
#  title      :string
#  created_at :datetime
#  updated_at :datetime
#  tenant_id  :integer
#
# Indexes
#
#  index_posts_on_tenant_id  (tenant_id)
#
class Post < ApplicationRecord
  include Sportified::TenantScoped
  acts_as_taggable
  paginates_per 10

  has_one_attached :photo, service: :local
  has_many_attached :references, service: :local

  mount_uploader :image, ImageUploader

  scope :newest_first, -> { order(created_at: :desc) }
  scope :newest, -> { order(created_at: :desc) }
  scope :random, -> { order(Arel.sql('RANDOM()')) }

  validates :title, presence: true

  def as_json(options = {})
    super(options).merge(photo_url: if photo.attached?
                                      Rails.application.routes.url_helpers.rails_blob_path(photo,
                                                                                           only_path: true)
                                    end)
  end

  before_save :attach_references_from_body

  ATTACHMENTS_REGEX = %r{/rails/active_storage/blobs/proxy/([\w-]+)/}

  def attach_references_from_body
    body.scan(ATTACHMENTS_REGEX)
        .map { |match| ActiveStorage::Blob.find_signed(match[0]) }
        .compact_blank
        .uniq(&:id)
        .reject { |blob| references_blob_ids.include?(blob.id) }
        .each { |blob| references.attach(blob) }
  end
end

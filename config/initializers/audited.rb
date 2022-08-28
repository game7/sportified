# List of classes deemed safe to load by YAML, and required by the Audited
# gem when deserialized audit records.
#
# As of Rails 6.0.5.1, YAML safe-loading method does not allow all classes
# to be deserialized by default: https://discuss.rubyonrails.org/t/cve-2022-32224-possible-rce-escalation-bug-with-serialized-columns-in-active-record/81017
#
# Thread here: https://github.com/collectiveidea/audited/issues/631
Rails.application.config.active_record.yaml_column_permitted_classes = [
  ActiveSupport::HashWithIndifferentAccess,
  ActiveSupport::TimeWithZone,
  ActiveSupport::TimeZone,
  ActsAsTaggableOn::DefaultParser,
  ActsAsTaggableOn::TagList,
  Date,
  Symbol,
  Time
]
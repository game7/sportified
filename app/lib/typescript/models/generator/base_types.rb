module Typescript::Models::Generator::BaseTypes
  extend ActiveSupport::Concern

  def base_types
    out = []
    out.concat active_storage_attached_one
    out.concat active_storage_attached_many
    out
  end

  def active_storage_attached_one # rubocop:disable Metrics/MethodLength
    out = []
    out << '// this is a special class that provides access to an'
    out << '// attachment but also allows setting attachment'
    out << '// via a File or signed_id (string)'
    out << 'namespace ActiveStorage {'
    out << '  namespace Attached {'
    out << '    type One = string | File | {'
    out << '      attachment?: ActiveStorage.Attachment;'
    out << '    }'
    out << '  }'
    out << '}'
    out
  end

  def active_storage_attached_many # rubocop:disable Metrics/MethodLength
    out = []
    out << '// this is a special class that provides access to the'
    out << '// attachments but also allows setting attachments'
    out << '// via an array of Files or signed_ids (string)'
    out << 'namespace ActiveStorage {'
    out << '  namespace Attached {'
    out << '    type Many = string[] | File[] | {'
    out << '      attachments?: ActiveStorage.Attachment[]'
    out << '      blobs?: ActiveStorage.Blob[];'
    out << '    }'
    out << '  }'
    out << '}'
    out
  end
end

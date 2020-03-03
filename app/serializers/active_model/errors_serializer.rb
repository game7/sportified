module ActiveModel
  class ErrorsSerializer < ActiveModel::Serializer
    attributes :messages
    def messages
      object.messages
    end
    def json_key
      'errors'
    end
  end
end
require 'digest/md5'

class TagSerializer < ActiveModel::Serializer
  attributes :id, :name, :color

  def id
    object.id.to_s
  end

  def color
    '#' + Digest::MD5.hexdigest(object.name)[0..5]
  end

end

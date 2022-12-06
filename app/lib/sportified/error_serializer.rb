module Sportified
  module ErrorSerializer
    def ErrorSerializer.serialize(errors)
      return if errors.nil?

      json = {}
      new_hash = errors.to_hash(true).map do |k, v|
        v.map do |msg|
          { id: k, title: msg }
        end
      end.flatten
      json.tap{|obj| obj[:errors] = new_hash}
    end
  end
end

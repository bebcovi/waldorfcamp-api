require "json"
require "yaks"

module Waldorfcamp
  class Serializer
    def self.call(object)
      new.serialize(object)
    end

    def serialize(object)
      case object
      when Hash, Array
        object.to_json
      when Sequel::Dataset
        yaks.call(object.all)
      when Sequel::Model
        yaks.call(object)
      end
    end

    private

    def yaks
      Yaks.new do
        default_format :json_api
        mapper_namespace Waldorfcamp
        map_to_primitive Date, Time, &:iso8601
        map_to_primitive Sequel::Postgres::JSONBHash, &:to_hash
      end
    end
  end

  class PhotoMapper < Yaks::Mapper
    attribute(:id)
    attribute(:url) { object.images.fetch("url") }
    attribute(:width) { object.images.fetch("width") }
    attribute(:height) { object.images.fetch("height") }
    attribute(:tags)
    attribute(:uploaded_at)
  end
end

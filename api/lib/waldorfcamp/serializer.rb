require "json"
require "yaks"

module Waldorfcamp
  class Serializer
    CLASSES = [Hash, Array, Sequel::Dataset, Sequel::Model]

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
    attributes :id, :description, :small, :medium, :large

    def small
      object.images["small"]
    end

    def medium
      object.images["medium"]
    end

    def large
      object.images["large"]
    end
  end
end

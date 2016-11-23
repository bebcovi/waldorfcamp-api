require "cloudinary"

module Waldorfcamp
  class Cloudinary
    def initialize(options)
      ::Cloudinary.config(options)
    end

    def photos
      get_photos do |hashes|
        photos = hashes.map do |hash|
          {
            id:          hash.fetch("public_id"),
            images: {
              url:       hash.fetch("secure_url"),
              width:     hash.fetch("width"),
              height:    hash.fetch("height"),
            },
            uploaded_at: hash.fetch("created_at"),
            tags:        hash.fetch("tags").join(","),
          }
        end

        yield photos
      end
    end

    private

    def get_photos
      cursor = nil

      loop do
        result = fetch_photos(cursor: cursor)
        yield result.fetch("resources")
        break unless cursor = result["next_cursor"]
      end
    end

    def fetch_photos(cursor: nil)
      ::Cloudinary::Api.resources(
        max_results: 500,
        next_cursor: cursor,
        tags: true,
      )
    end
  end
end

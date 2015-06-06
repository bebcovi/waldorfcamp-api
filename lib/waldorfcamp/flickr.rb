require "flickr-objects"

module Waldorfcamp
  class Flickr
    def initialize(api_key, user_id)
      ::Flickr.configure { |c| c.api_key = api_key }
      @user_id = user_id
    end

    def photos(**options)
      get_photos(**options).map do |photo|
        images = photo.available_sizes.reverse.each_with_object({}) do |size, info|
          photo = photo.send(:size!, size)

          case photo.width
          when 0...400    then key = "small"
          when 400...800  then key = "medium"
          when 800...1200 then key = "large"
          end

          info[key] ||= {
            "width"  => photo.width,
            "height" => photo.height,
            "url"    => photo.source_url,
          } if key
        end

        original_photo = photo.original
        raise "no original photo for flickr image #{photo.id}" if original_photo.width.nil?
        images["original"] = {
          "width"  => original_photo.width,
          "height" => original_photo.height,
          "url"    => original_photo.source_url,
        }

        {
          id:          photo.id,
          description: photo.title,
          images:      images,
          uploaded_at: photo.uploaded_at,
          tags:        photo["tags"].to_s.split(" ").join(","),
        }
      end
    end

    private

    def get_photos(**options)
      photos = []

      1.step do |page|
        photos_page = fetch_photos(**options, page: page)
        photos += photos_page.to_ary
        return photos if photos_page.empty?
      end
    end

    def fetch_photos(page: 1, since: 1, tries: 5)
      person.get_public_photos(
        sizes: true,
        extras: "description,date_upload,tags",
        page: page,
      )
    rescue ::Flickr::TimeoutError
      tries -= 1
      retry if tries > 0
      raise
    end

    def person
      ::Flickr.people.find(@user_id)
    end
  end
end

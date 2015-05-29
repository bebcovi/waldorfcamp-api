require "koala"

module Waldorfcamp
  class Facebook
    def initialize(access_token)
      @access_token = access_token
    end

    def photos(**options)
      get_photos(**options).map do |photo|
        images = photo.fetch("images")
          .sort_by { |image| image["width"] }.reverse
          .each_with_object({}) do |image, info|
            case image.fetch("width")
            when 0...400    then key = "small"
            when 400...800  then key = "medium"
            when 800...1200 then key = "large"
            end

            info[key] ||= {
              "width"  => image.fetch("width"),
              "height" => image.fetch("height"),
              "url"    => image.fetch("source"),
            } if key
          end

        {
          id:          photo.fetch("id"),
          description: photo["name"], # not mandatory
          images:      images,
          uploaded_at: photo.fetch("created_time"),
        }
      end
    end

    private

    def get_photos(**options)
      photos, cursor = [], nil

      loop do
        photos_page = fetch_photos(**options, after: cursor)
        photos += photos_page.to_ary
        return photos if photos_page.empty?
        cursor = photos_page.paging.fetch("cursors")["after"]
      end
    end

    def fetch_photos(after: nil, since: 1, tries: 3)
      begin
        client.get_object("waldorfcamp/photos", type: "uploaded", after: after)
      rescue Koala::Facebook::ServerError
        tries -= 1
        retry if tries > 0
        raise
      end
    end

    def client
      Koala::Facebook::API.new(@access_token)
    end
  end
end

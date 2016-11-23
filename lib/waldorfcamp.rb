require "waldorfcamp/app"
require "waldorfcamp/cloudinary"

module Waldorfcamp
  def self.app
    App.freeze.app
  end

  def self.cloudinary
    Cloudinary.new(
      cloud_name: ENV.fetch("CLOUDINARY_NAME"),
      api_key:    ENV.fetch("CLOUDINARY_KEY"),
      api_secret: ENV.fetch("CLOUDINARY_SECRET"),
    )
  end
end

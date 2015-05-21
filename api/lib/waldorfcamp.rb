require "waldorfcamp/app"
require "waldorfcamp/facebook"
require "waldorfcamp/flickr"

module Waldorfcamp
  def self.app
    App.freeze.app
  end

  def self.facebook
    Facebook.new(ENV.fetch("FACEBOOK_ACCESS_TOKEN"))
  end

  def self.flickr
    Flickr.new(ENV.fetch("FLICKR_API_KEY"), ENV.fetch("FLICKR_USER"))
  end
end

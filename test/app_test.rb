require "test_helper"
require "rack/test"
require "json"
require "pry"

class AppTest < Minitest::Test
  include Rack::Test::Methods

  def app
    Waldorfcamp.app
  end

  def body
    JSON.parse(last_response.body)
  end

  def test_photos
    get "/photos", page: 1, perPage: 25

    refute_empty body["data"]
  end
end

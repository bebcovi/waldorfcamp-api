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

  def test_attributes
    get "/photos", page: 1, perPage: 25

    refute_empty body["data"]
    assert_equal 25, body["data"].count

    attributes = body["data"][0]["attributes"]

    refute_equal nil, attributes["url"]
    refute_equal nil, attributes["width"]
    refute_equal nil, attributes["height"]
    refute_equal nil, attributes["tags"]
    refute_equal nil, attributes["uploaded_at"]
  end

  def test_ordering
    get "/photos", page: 1, perPage: 25
    assert_equal 25, body["data"].count
  end

  def test_tags
    get "/photos", page: 1, perPage: 25, tags: "mime"
    refute_empty body["data"]

    get "/photos", page: 1, perPage: 25, tags: "mime,workshop"
    refute_empty body["data"]

    get "/photos", page: 1, perPage: 25, tags: "foo"
    assert_empty body["data"]
  end
end

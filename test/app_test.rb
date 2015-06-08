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

    assert_includes attributes.keys, "small"
    assert_includes attributes.keys, "medium"
    assert_includes attributes.keys, "large"
    assert_includes attributes.keys, "original"

    assert_includes attributes.keys, "tags"
    assert_includes attributes.keys, "description"
    assert_includes attributes.keys, "source"
    assert_includes attributes.keys, "uploaded_at"
  end

  def test_ordering
    get "/photos", page: 1, perPage: 25
    attributes = body["data"][0]["attributes"]
    assert_equal "facebook", attributes.fetch("source")
  end

  def test_tags
    get "/photos", page: 1, perPage: 25, tags: "caxixi"
    refute_empty body["data"]

    get "/photos", page: 1, perPage: 25, tags: "caxixi,workshop"
    refute_empty body["data"]

    get "/photos", page: 1, perPage: 25, tags: "foo"
    assert_empty body["data"]
  end
end

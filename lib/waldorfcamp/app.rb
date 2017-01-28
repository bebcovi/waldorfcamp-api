require "roda"
require "sequel"
require "yaml"

if ENV["RACK_ENV"] == "production"
  DB = Sequel.connect(ENV.fetch("DATABASE_URL"))
else
  db_config = YAML.load_file("config/database.yml")
  db_config = db_config.fetch(ENV["RACK_ENV"] || "development")
  DB = Sequel.connect(db_config)
end

DB.extension :pg_json
DB.extension :pagination

require "waldorfcamp/photo"
require "waldorfcamp/serializer"

module Waldorfcamp
  class App < Roda
    plugin :json, classes: Serializer::CLASSES, serializer: Serializer
    plugin :symbolized_params
    plugin :default_headers, "Access-Control-Allow-Origin"=>"*"

    route do |r|
      r.get "photos" do
        page_number = Integer(params.fetch(:page))
        page_size   = Integer(params.fetch(:perPage))
        tags        = params[:tags].to_s.split(",")

        Photo.newest.tagged_with(tags).paginate(page_number, page_size)
      end
    end
  end
end

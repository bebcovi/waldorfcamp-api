require "rake/testtask"

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/**/*_test.rb']
end

task :default => :test

namespace :db do
  task :setup => ['db:create', 'db:migrate']

  task :create do
    sh "createdb waldorfcamp"
  end

  task :migrate, [:version] do |task, args|
    sequel migrate: (args[:version] || true)
  end

  task :demigrate do
    sequel migrate: 0
  end

  task :remigrate => [:demigrate, :migrate]

  def sequel(migrate: nil)
    args = []

    if migrate
      args += %W[-m db/migrations]
      args += %W[-M #{migrate}] if String === migrate
    end

    args += %W[#{ENV["DATABASE_URL"] || "postgres:///waldorfcamp"}]

    sh ["sequel", *args].join(" ")
  end
end

task :cache_photos => [:cache_facebook_photos, :cache_flickr_photos]

task :cache_facebook_photos => :setup do
  cache_photos("facebook")
end

task :cache_flickr_photos => :setup do
  cache_photos("flickr")
end

task :console => :setup do
  ARGV.clear
  require "pry"
  Pry.start
end

task :setup do
  require "waldorfcamp"
  require "dotenv"

  Dotenv.load! unless ENV["RACK_ENV"] == "production"
end

def cache_photos(source)
  photos = Waldorfcamp.send(source).photos.map do |photo|
    photo.merge(
      source: source,
      images: Sequel.pg_jsonb(photo[:images]),
    )
  end

  DB[:photos].where(source: source).delete
  DB[:photos].multi_insert(photos)

  puts "#{photos.count} #{source.capitalize} photos stored"
end

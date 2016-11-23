require "rake/testtask"

Rake::TestTask.new do |t|
  t.libs << "test"
  t.test_files = FileList['test/**/*_test.rb']
  t.warning = false
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

    args += %W[-e #{ENV["RACK_ENV"] || "development"} config/database.yml]

    sh ["sequel", *args].join(" ")
  end
end

task :cache_photos => :setup do
  DB[:photos].delete
  count = 0

  Waldorfcamp.cloudinary.photos do |photos|
    records = photos.map do |photo|
      photo.merge(
        source: "cloudinary",
        images: Sequel.pg_jsonb(photo[:images])
      )
    end

    DB[:photos].multi_insert(records)

    count += records.count
  end

  puts "#{count} cloudinary photos stored"
end

task :console => :setup do
  ARGV.clear
  require "pry"
  Pry.start
end

task :setup do
  require "waldorfcamp"
  require "dotenv"

  Dotenv.load!
end

Gem::Specification.new do |gem|
  gem.name          = "waldorfcamp"
  gem.version       = "0.0.1"

  gem.required_ruby_version = ">= 2.2.0"

  gem.description   = "API for Waldorfcamp"
  gem.summary       = "The API endpoint used internally by http://waldorfcamp.net"
  gem.homepage      = "https://github.com/twin/waldorfcamp"

  gem.authors       = ["Janko Marohnic"]
  gem.email         = ["janko.marohnic@gmail.com"]

  gem.files         = Dir["README.md", "lib/**/*"]
  gem.require_path  = "lib"


  # Web
  gem.add_dependency "roda"
  gem.add_dependency "roda-symbolized_params"
  gem.add_dependency "yaks"
  gem.add_dependency "unicorn"
  gem.add_dependency "rack-cors"

  # Database
  gem.add_dependency "sequel"
  gem.add_dependency "pg"

  # Photos
  gem.add_dependency "flickr-objects"
  gem.add_dependency "koala"
  gem.add_dependency "dotenv"

  # Development
  gem.add_dependency "rake"

  # Testing
  gem.add_development_dependency "minitest"
  gem.add_development_dependency "minitest-hooks"
  gem.add_development_dependency "rack-test"
end

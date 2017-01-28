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
end

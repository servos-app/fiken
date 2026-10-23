require_relative "lib/fiken/version"

Gem::Specification.new do |spec|
  spec.name = "fiken"
  spec.version = Fiken::VERSION
  spec.authors = ["SERVOS"]
  spec.email = ["a@asgerbehnckejacobsen.dk"]

  spec.summary = "Ruby client for the Fiken accounting API (v2)"
  spec.description = "A client for the Fiken API v2 and its OAuth2 flow. Plain Ruby, no runtime dependencies."
  spec.homepage = "https://github.com/servos-app/fiken"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 3.4"

  spec.files = Dir["lib/**/*.rb"]
  spec.require_paths = ["lib"]
end

# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "rollerskates/version"

Gem::Specification.new do |spec|
  spec.name          = "rollerskates"
  spec.version       = Rollerskates::VERSION
  spec.authors       = ["Femi Senjobi"]
  spec.email         = ["femi.senjobi@andela.com"]

  spec.summary       = "This is a micro-MVC framework"
  spec.description   = "This is a ruby MVC framework to speed up development time."
  spec.homepage      = "https://gitbub.com/andela-fsenjobi/rollerskates"
  spec.license       = "MIT"

  # Prevent pushing this gem to RubyGems.org by setting 'allowed_push_host', or
  # delete this section to allow pushing this gem to any host.
  if spec.respond_to?(:metadata)
    spec.metadata["allowed_push_host"] = "https://rubygems.org"
  else
    raise "RubyGems 2.0 or newer is required to protect against public gem pushes."
  end

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.9"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "coveralls", "~> 0"
  spec.add_development_dependency "capybara", "~> 2.6"

  spec.add_runtime_dependency "rack", "~> 1.0"
  spec.add_runtime_dependency "tilt", "~> 0"
  spec.add_runtime_dependency "pry", "~> 0"
  spec.add_runtime_dependency "sqlite3", "~> 1.3.11"

end

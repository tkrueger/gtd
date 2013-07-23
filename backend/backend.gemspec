# coding: utf-8
lib = File.expand_path('../app', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'backend/version'

Gem::Specification.new do |spec|
  spec.name          = "backend"
  spec.version       = Backend::VERSION
  spec.authors       = ["Thorsten Krüger"]
  spec.email         = ["thorstenkg@googlemail.com"]
  spec.description   = %q{gtd backend}
  spec.summary       = %q{write model and infrastructure of gtd}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(spec|spec|features)/})
  spec.require_paths = ["app"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "guard-rspec"
  spec.add_development_dependency "libnotify"

  spec.add_dependency "sinatra"
  spec.add_dependency "thin"
end

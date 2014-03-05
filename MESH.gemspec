# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'MESH/version'

Gem::Specification.new do |spec|
  spec.name          = "mesh-medical-subject-headings"
  spec.version       = Mesh::VERSION
  spec.authors       = ["mmmmmrob"]
  spec.email         = ["rob@dynamicorange.com"]
  spec.description   = %q{A ruby gem containing MeSH subject headings (https://www.nlm.nih.gov/mesh/) for use in classifying and entity recognition.}
  spec.summary       = %q{A ruby gem containing MeSH subject headings (https://www.nlm.nih.gov/mesh/) for use in classifying and entity recognition.}
  spec.homepage      = ""
  spec.license       = "AGPL3"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = nil
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "mocha"
  spec.add_development_dependency "yard"
  spec.add_development_dependency "minitest", "~> 5.0.8"
  spec.add_development_dependency "ruby-prof"
end

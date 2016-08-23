# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'attribute_depends_calculator/version'

Gem::Specification.new do |spec|
  spec.name          = "attribute-depends-calculator"
  spec.version       = AttributeDependsCalculator::VERSION
  spec.authors       = ["Jason Hou"]
  spec.email         = ["hjj1992@gmail.com"]

  spec.summary       = %q{calculate depends attribute automatically}
  spec.description   = %q{auto calculate collect of depends attribute value and save when that changes}
  spec.homepage      = "https://github.com/falm/attribute-depends-calculator"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]
  spec.licenses      = ["MIT"]

  spec.required_ruby_version = '>= 2.0'
  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency 'rack', '~> 1.5'
end

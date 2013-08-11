# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'simple_cipher/version'

Gem::Specification.new do |spec|
  spec.name          = 'simple_cipher'
  spec.version       = SimpleCipher::VERSION
  spec.authors       = ['Yoshi OOTA']
  spec.email         = ['yoshi.oota@gmail.com']
  spec.description   = %q{wrapping cipher. and cache key_iv.}
  spec.summary       = %q{wrapping cipher. and cache key_iv.}
  spec.homepage      = ''
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'activesupport', '~> 3.1'

  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'

  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'guard'
  spec.add_development_dependency 'guard-rspec'
  spec.add_development_dependency 'debugger'
end

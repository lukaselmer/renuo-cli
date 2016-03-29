# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'renuo/cli/version'

Gem::Specification.new do |spec|
  spec.name = 'renuo-cli'
  spec.version = Renuo::Cli::VERSION
  spec.authors = ['Lukas Elmer']
  spec.email = ['lukas.elmer@gmail.com']

  spec.summary = 'The Renuo CLI automates some commonly used workflows by providing a command line interface.'
  spec.description = 'The Renuo CLI automates some commonly used workflows by providing a command line interface.'
  spec.homepage = 'https://github.com/renuo/renuo-cli'
  spec.license = 'MIT'

  spec.files = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'commander'

  spec.add_development_dependency 'bundler', '~> 1.10'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec'
  spec.add_development_dependency 'cucumber'
  spec.add_development_dependency 'aruba'
  spec.add_development_dependency 'rubocop'
  spec.add_development_dependency 'pry'
  spec.add_development_dependency 'coveralls'
  spec.add_development_dependency 'redcarpet'
end

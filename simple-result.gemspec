# frozen_string_literal: true

require_relative 'lib/simple_result/version'

Gem::Specification.new do |spec|
  spec.name = 'simple-result'
  spec.version = SimpleResult::VERSION
  spec.authors = ['Lucian Ghinda']
  spec.email = ['lucian@shortruby.com']

  spec.summary = 'A simple response monad implementation'
  spec.description = 'A one file less than 100LOC, idiomatic Ruby implementation' \
                     'of a response monad for handling success and failure states'
  spec.homepage = 'https://github.com/lucianghinda/simple_result'
  spec.license = 'MIT'
  spec.required_ruby_version = '>= 3.4.4'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/lucianghinda/simple-result'
  spec.metadata['changelog_uri'] = 'https://github.com/lucianghinda/web-author/CHANGELOG.md'

  spec.files = Dir['lib/**/*.rb', 'README.md', 'LICENSE.txt']
  spec.require_paths = ['lib']
  spec.metadata['rubygems_mfa_required'] = 'true'

  spec.add_dependency 'zeitwerk', '~> 2.6'
end

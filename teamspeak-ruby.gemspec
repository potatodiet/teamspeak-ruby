require './lib/teamspeak-ruby/version'
require 'date'

Gem::Specification.new do |s|
  s.name          = 'teamspeak-ruby'
  s.version       = Teamspeak::VERSION
  s.date          = Date.today.to_s
  s.summary       = 'Ruby interface for TeamSpeak 3\'s server query api.'
  s.authors       = ['Justin Harrison']
  s.email         = 'me@justinharrison.ca'
  s.files         = Dir.glob('lib/**/*')
  s.require_paths = ['lib']
  s.homepage      = 'https://github.com/matthin/teamspeak-ruby'
  s.license       = 'MIT'
  s.add_development_dependency 'guard', '~> 2.0'
  s.add_development_dependency 'guard-shell', '~> 0.7'
  s.add_development_dependency 'minitest', '~> 5.0'
  s.add_development_dependency 'rake', '~> 12.0'
  s.add_development_dependency 'rubocop', '~> 0.42'
end

require './lib/teamspeak-ruby/version'

Gem::Specification.new do |s|
  s.name          = 'teamspeak-ruby'
  s.version       = Teamspeak::VERSION
  s.date          = Date.today.to_s
  s.summary       = 'Ruby interface for TeamSpeak 3\'s server query api.'
  s.authors       = ['Justin Harrison']
  s.email         = 'justin@pyrohail.com'
  s.files         = Dir.glob('lib/**/*')
  s.require_paths = ['lib']
  s.homepage      = 'http://pyrohail.com'
  s.license       = 'MIT'
end

require_relative '../lib/teamspeak-ruby'

ts = Teamspeak.new('127.0.0.1')
ts.login('serveradmin', 'travis_test')
ts.command('use', {'sid' => 1})

puts ts.command('hostinfo')

ts.disconnect

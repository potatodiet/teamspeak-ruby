require 'teamspeak-ruby'

begin
  ts = Teamspeak::Client.new('127.0.0.1')
  ts.login('serveradmin', 'T5I3A1G8')
  ts.command('use', {'sid' => 27})

  ts.disconnect
rescue Teamspeak::ServerError => error
  error.code  #=> 1033
  error.message  #=> 'server is not running'
end

require 'teamspeak-ruby'

begin
  ts = Teamspeak::Client.new
  ts.login('serveradmin', 'T5I3A1G8')
  ts.command('use', {'sid' => 27})

  ts.disconnect
rescue Teamspeak::ServerError => error
  error.code  #=> 1033
  error.message  #=> 'server is not running'
end

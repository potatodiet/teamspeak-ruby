$LOAD_PATH << File.join(File.dirname(__FILE__), '..', 'lib')
require 'teamspeak-ruby'

begin
  ts = Teamspeak::Client.new('direct.pyrohail.com')

  ts.login('serveradmin', 'K4ElR6t0')
  ts.command('use', {'sid' => 1})

  ts.command('clientlist').each do |user|
    puts user
  end

  ts.disconnect
rescue Teamspeak::ServerError => error
  puts error.code
  puts error.message
end

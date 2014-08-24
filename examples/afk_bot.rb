# Built to be run as a cron job every few minutes or so, however can be easily
# adapted to run with just a loop, and sleep after each run.
# Could be much more advanced by using a built in storage of users
# and their current idle time to minimize hitting the teamspeak server.

require 'teamspeak-ruby'

AFK_TIME = 30 # AFK time in minutes
AFK_CHANNEL = 67 # AFK channel clid

ts = Teamspeak::Client.new
ts.login('serveradmin', 'T5I3A1G8')
ts.command('use', {'sid' => 1})

ts.command('clientlist').each do |user|
  idle_time = ts.command('clientinfo', {'clid' => user['clid']})['client_idle_time']

  # turn milliseconds to seconds to minutes
  if idle_time / 1000 / 60 >= AFK_TIME
    if user['cid'] != AFK_CHANNEL
      ts.command('clientmove', {'clid' => user['clid'], 'cid' => AFK_CHANNEL})
      ts.command('clientpoke', {'clid' => user['clid'],
                                'msg' => 'You have been moved to the AFK channel'})
    end
  end
end

ts.disconnect

teamspeak-ruby
----------
[![Build Status](https://travis-ci.org/pyrohail/teamspeak-ruby.png?branch=master)]
(https://travis-ci.org/pyrohail/teamspeak-ruby)
[![Gem Version](https://badge.fury.io/rb/teamspeak-ruby.png)]
(http://badge.fury.io/rb/teamspeak-ruby)

Ruby interface for TeamSpeak 3's [server query]
(http://media.teamspeak.com/ts3_literature/TeamSpeak%203%20Server%20Query%20Manual.pdf) api.

Install
----------
```shell
gem install teamspeak-ruby
```

Usage
----------
```ruby
require 'teamspeak-ruby'

ts = Teamspeak.new('127.0.0.1')
ts.login('serveradmin', 'T5I3A1G8')
ts.command('use', {'sid' => 1})

ts.command('clientlist').each do |user|
  if user['client_nickname'] == 'Example Client'
    ts.command('clientpoke', {'clid' => user['clid'], 'msg' => 'Just an example!'})
  end
end

puts ts.command('hostinfo')['host_timestamp_utc']

ts.disconnect
```

Error Handling
----------
```ruby
require 'teamspeak-ruby'

begin
  ts = Teamspeak.new('127.0.0.1')
  ts.login('serveradmin', 'T5I3A1G8')
  ts.command('use', {'sid' => 27})

  ts.disconnect
rescue Teamspeak::ServerError => error
  error.code  #=> 1033
  error.message  #=> 'server is not running'
end
```

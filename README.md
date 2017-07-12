teamspeak-ruby
----------
[![Build Status](https://travis-ci.org/matthin/teamspeak-ruby.png?branch=master)]
(https://travis-ci.org/matthin/teamspeak-ruby)
[![Gem Version](https://badge.fury.io/rb/teamspeak-ruby.png)]
(http://badge.fury.io/rb/teamspeak-ruby)

Ruby interface for TeamSpeak 3's [server query]
(http://media.teamspeak.com/ts3_literature/TeamSpeak%203%20Server%20Query%20Manual.pdf) api.
Built against the manual released on 2012-02-29.

Install
----------
```shell
gem install teamspeak-ruby
```

Usage
----------
```ruby
require 'teamspeak-ruby'

ts = Teamspeak::Client.new
ts.login('serveradmin', 'T5I3A1G8', 1, 'Server Bot')

ts.clientlist.each do |user|
  if user['client_nickname'] == 'Example Client'
    ts.clientpoke(clid: user['clid'], msg: 'Just an example!')
  end
end

ts.clientmessage(clid: ts.getclient('Example Client')['clid'], msg: 'Another example!')

puts ts.hostinfo['host_timestamp_utc']

ts.disconnect
```

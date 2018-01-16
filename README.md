teamspeak-ruby
----------
[![Travis](https://img.shields.io/travis/matthin/teamspeak-ruby.svg)](https://travis-ci.org/matthin/teamspeak-ruby)
[![Gem](https://img.shields.io/gem/v/teamspeak-ruby.svg)](https://rubygems.org/gems/teamspeak-ruby/)
[![Gem](https://img.shields.io/gem/dt/teamspeak-ruby.svg)](https://rubygems.org/gems/teamspeak-ruby/)

Ruby interface for TeamSpeak 3's [Server Query](http://media.teamspeak.com/ts3_literature/TeamSpeak%203%20Server%20Query%20Manual.pdf) API.
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

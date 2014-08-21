Setup - Linux
----------
```shell
wget http://dl.4players.de/ts/releases/3.0.10.3/teamspeak3-server_linux-amd64-3.0.10.3.tar.gz
tar xzf teamspeak3-server_linux-amd64-3.0.10.3.tar.gz
cd teamspeak3-server_linux-amd64
./ts3server_startscript.sh start serveradmin_password=travis_test
```

Testing
----------
```shell
ruby /tests/test.rb
```

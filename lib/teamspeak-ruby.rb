require 'socket'

class Teamspeak
  def initialize(host = 'localhost', port = 10011)
    self.connect(host, port)
  end

  def connect(host = 'localhost', port = 10011)
    @sock = TCPSocket.new(host, port)

    # Check if the response is the same as a normal teamspeak 3 server.
    if @sock.gets.strip != 'TS3'
      puts 'This is not responding as a TeamSpeak 3 server.'

      return false
    end

    # Remove useless text from the buffer.
    @sock.gets
  end

  def disconnect
    @sock.puts 'quit'
    @sock.close
  end

  def login(user, pass)
    self.command('login', {'client_login_name' => user, 'client_login_password' => pass})
  end

  def command(cmd, params = {}, options = '')
    out = ''
    response = ''

    out += cmd

    params.each_pair do |key, value|
      out += " #{key}=#{encode_param(value.to_s)}"
    end

    out += ' ' + options

    @sock.puts out

    while true
      response += @sock.gets
      
      if response.index('msg=')
        break
      end
    end

    # Array of commands that are expected to return as an array.
    # Not sure - clientgetids
    should_be_array = ['bindinglist', 'serverlist', 'servergrouplist', 'servergroupclientlist',
        'servergroupsbyclientid', 'servergroupclientlist', 'logview', 'channellist',
        'channelfind', 'channelgrouplist', 'channelgrouppermlist', 'channelpermlist', 'clientlist',
        'clientfind', 'clientdblist', 'clientdbfind', 'channelclientpermlist', 'permissionlist',
        'permoverview', 'privilegekeylist', 'messagelist', 'complainlist', 'banlist', 'ftlist',
        'custominfo']

    parsed_response = parse_response(response)

    return should_be_array.include?(cmd) ? parsed_response : parsed_response.first
  end

  def parse_response(response)
    out = []

    response = response.split('error id=').first

    response.split('|').each do |key|
      data = {}

      key.split(' ').each do |key|
        value = key.split('=')

        data[value[0]] = decode_param(value[1].to_s)
      end

      out.push(data)
    end

    return out
  end

  def decode_param(param)
    param = param.gsub('\\\\', '\\')
    param = param.gsub('\\/', '/')
    param = param.gsub('\\s', ' ')
    param = param.gsub('\\p', '|')
    param = param.gsub('\\a', '\a')
    param = param.gsub('\\b', '\b')
    param = param.gsub('\\f', '\f')
    param = param.gsub('\\n', '\n')
    param = param.gsub('\\r', '\r')
    param = param.gsub('\\t', '\t')
    param = param.gsub('\\v', '\v')

    return param == '' ? nil : param
  end

  def encode_param(param)
    param = param.gsub('\\', '\\\\')
    param = param.gsub('/', '\\/')
    param = param.gsub(' ', '\\s')
    param = param.gsub('|', '\\p')
    param = param.gsub('\a', '\\a')
    param = param.gsub('\b', '\\b')
    param = param.gsub('\f', '\\f')
    param = param.gsub('\n', '\\n')
    param = param.gsub('\r', '\\r')
    param = param.gsub('\t', '\\t')
    param = param.gsub('\v', '\\v')

    return param
  end
end

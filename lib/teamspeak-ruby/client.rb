require 'socket'

module Teamspeak
  class Client
    # Connects to a TeamSpeak 3 server
    #
    #   connect('voice.domain.com', 88888)
    def initialize(host = 'localhost', port = 10011)
      connect(host, port)
    end

    # Connects to a TeamSpeak 3 server
    #
    #   connect('voice.domain.com', 88888)
    def connect(host = 'localhost', port = 10011)
      @sock = TCPSocket.new(host, port)

      # Check if the response is the same as a normal teamspeak 3 server.
      if @sock.gets.strip != 'TS3'
        raise InvalidServer, 'Server is not responding as a normal TeamSpeak 3 server.'
      end

      # Remove useless text from the buffer.
      @sock.gets
    end

    # Disconnects from the TeamSpeak 3 server
    def disconnect
      @sock.puts 'quit'
      @sock.close
    end

    # Authenticates with the TeamSpeak 3 server
    #
    #   login('serveradmin', 'H8YlK1f9')
    def login(user, pass)
      command('login', {'client_login_name' => user, 'client_login_password' => pass})
    end

    # Sends command to the TeamSpeak 3 server and returns the response
    #
    #   command('use', {'sid' => 1}, '-away')
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

      response.split('|').each do |key|
        data = {}

        key.split(' ').each do |key|
          value = key.split('=')

          data[value[0]] = decode_param(value[1].to_s)
        end

        out.push(data)
      end

      check_response_error(out)

      return out
    end

    def decode_param(param)
      param.gsub!('\\\\', '\\')
      param.gsub!('\\/', '/')
      param.gsub!('\\s', ' ')
      param.gsub!('\\p', '|')
      param.gsub!('\\a', '\a')
      param.gsub!('\\b', '\b')
      param.gsub!('\\f', '\f')
      param.gsub!('\\n', '\n')
      param.gsub!('\\r', '\r')
      param.gsub!('\\t', '\t')
      param.gsub!('\\v', '\v')

      return param == '' ? nil : param
    end

    def encode_param(param)
      param.gsub!('\\', '\\\\')
      param.gsub!('/', '\\/')
      param.gsub!(' ', '\\s')
      param.gsub!('|', '\\p')
      param.gsub!('\a', '\\a')
      param.gsub!('\b', '\\b')
      param.gsub!('\f', '\\f')
      param.gsub!('\n', '\\n')
      param.gsub!('\r', '\\r')
      param.gsub!('\t', '\\t')
      param.gsub!('\v', '\\v')

      return param
    end

    def check_response_error(response)
      id = response.first['id']
      message = response.first['msg']

      raise ServerError.new(id, message) unless id.to_i == 0
    end

    private(:parse_response, :decode_param, :encode_param, :check_response_error)
  end
end

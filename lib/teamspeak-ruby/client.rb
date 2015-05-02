require 'socket'

module Teamspeak
  class Client
    # Should commands be throttled? Default is true
    attr_writer(:flood_protection)
    # Number of commands within flood_time before pausing. Default is 10
    attr_writer(:flood_limit)
    # Length of time before flood_limit is reset in seconds. Default is 3
    attr_writer(:flood_time)

    # First is escaped char, second is real char.
    SPECIAL_CHARS = [
      ['\\\\', '\\'],
      ['\\/', '/'],
      ['\\s', ' '],
      ['\\p', '|'],
      ['\\a', '\a'],
      ['\\b', '\b'],
      ['\\f', '\f'],
      ['\\n', '\n'],
      ['\\r', '\r'],
      ['\\t', '\t'],
      ['\\v', '\v']
    ]

    # Initializes Client
    #
    #   connect('voice.domain.com', 88888)
    def initialize(host = 'localhost', port = 10011)
      connect(host, port)

      # Throttle commands by default unless connected to localhost
      @flood_protection = true unless host
      @flood_limit = 10
      @flood_time = 3

      @flood_timer = Time.new
      @flood_current = 0
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
      flood_control

      out = ''
      response = ''

      out += cmd

      params.each_pair do |key, value|
        out += " #{key}=#{encode_param(value.to_s)}"
      end

      out += ' ' + options

      @sock.puts out

      if cmd == 'servernotifyregister'
        2.times {response += @sock.gets}
        return parse_response(response)
      end

      while true
        response += @sock.gets
        
        if response.index(' msg=')
          break
        end
      end

      # Array of commands that are expected to return as an array.
      # Not sure - clientgetids
      should_be_array = [
        'bindinglist', 'serverlist', 'servergrouplist', 'servergroupclientlist',
        'servergroupsbyclientid', 'servergroupclientlist', 'logview', 'channellist',
        'channelfind', 'channelgrouplist', 'channelgrouppermlist', 'channelpermlist', 'clientlist',
        'clientfind', 'clientdblist', 'clientdbfind', 'channelclientpermlist', 'permissionlist',
        'permoverview', 'privilegekeylist', 'messagelist', 'complainlist', 'banlist', 'ftlist',
        'custominfo'
      ]

      parsed_response = parse_response(response)

      return should_be_array.include?(cmd) ? parsed_response : parsed_response.first
    end

    def parse_response(response)
      out = []

      response.split('|').each do |key|
        data = {}

        key.split(' ').each do |key|
          value = key.split('=', 2)

          data[value[0]] = decode_param(value[1])
        end

        out.push(data)
      end

      check_response_error(out)

      out
    end

    def decode_param(param)
      return nil unless param
      # Return as integer if possible
      return param.to_i if param.to_i.to_s == param

      SPECIAL_CHARS.each do |pair|
        param.gsub!(pair[0], pair[1])
      end

      param
    end

    def encode_param(param)
      SPECIAL_CHARS.each do |pair|
        param.gsub!(pair[1], pair[0])
      end

      param
    end

    def check_response_error(response)
      id = response.first['id'] || 0
      message = response.first['msg'] || 0

      raise ServerError.new(id, message) unless id == 0
    end

    def flood_control
      if @flood_protection
        @flood_current += 1

        flood_time_reached = Time.now - @flood_timer < @flood_time
        flood_limit_reached = @flood_current == @flood_limit

        if flood_time_reached && flood_limit_reached
          sleep(@flood_time)
        end

        if flood_limit_reached
          # Reset flood protection
          @flood_timer = Time.now
          @flood_current = 0
        end
      end
    end

    private(
        :parse_response, :decode_param, :encode_param,
        :check_response_error, :flood_control
    )
  end
end

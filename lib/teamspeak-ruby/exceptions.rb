module Teamspeak
  # Raised when the connected server does not respond as a normal TeamSpeak 3 would.
  #
  # raise InvalidServer, 'Server is not responding as a normal TeamSpeak 3 server.'
  class InvalidServer < StandardError; end

  # Raised when the server returns an error code other than 0.
  #
  # raise ServerError.new(1, 'Some generic error message')
  class ServerError < StandardError
    attr_reader(:code, :message)

    def initialize(code, message)
      @code = code
      @message = message
    end
  end
end

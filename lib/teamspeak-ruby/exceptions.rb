module Teamspeak
  class InvalidServer < StandardError; end

  class ServerError < StandardError
    attr_reader(:code, :message)

    def initialize(code, message)
      @code = code
      @message = message
    end
  end
end

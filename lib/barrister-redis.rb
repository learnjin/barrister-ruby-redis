require "barrister-redis/version"
require 'barrister'
require 'redis'

module Barrister

  class RedisTransport

    def initialize(database_url, list_name)
      @list_name = list_name
      @client = ::Redis.connect url: database_url
    end

    def request(message)
      # reply-to tells the server where we'll be listening
      request = {
        'reply_to' => 'reply-' + SecureRandom.uuid,
        'message'  => message
      }

      # insert our request at the head of the list
      @client.lpush(@list_name, JSON.generate(request))

      # pop last element off our list in a blocking fashion
      channel, response = @client.brpop(request['reply_to'], timeout=30)

      JSON.parse(response)['message']
    end

  end

  class RedisContainer

    def initialize(json_path, database_url, list_name, handlers)
      @list_name = list_name

      # establish connection to Redis
      @client = ::Redis.connect url: database_url

      # initialize service
      contract = Barrister::contract_from_file(json_path)
      @server  = Barrister::Server.new(contract)

      # register each provided handler
      handlers.each do |handler_klass|
        @server.add_handler handler_klass.to_s, handler_klass.new
      end
    end

    def start
      while true
        # pop last element off our list in a blocking fashion
        channel, request = @client.brpop(@list_name)

        parsed = JSON.parse request

        # reverse the message we were sent
        response = {
          'message' => @server.handle(parsed['message'])
        }

        # 'respond' by inserting our reply at the head of a 'reply'-list
        @client.lpush(parsed['reply_to'], JSON.generate(response))
      end
    end

  end

end

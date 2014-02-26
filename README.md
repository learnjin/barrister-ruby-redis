# Barrister::Redis

A Redis server-container and transport for Barrister RPC.

## Usage

To instantiate a Redis transport, you need only the URL of the Redis database
and the name of the list that client and server will be using as a message bus:

```ruby

list_name = 'foo_bar'
transport = Barrister::RedisTransport.new('redis://localhost:6379', list_name)

```

Instantiating a Redis container is easy as well, and follows a similar pattern:

```ruby

json_path    = './user_service.json'
database_url = 'redis://localhost:6379'
list_name    = 'foo_bar'
handlers     = [UserService]

container = Barrister::RedisContainer.new json_path, database_url, list_name, handlers
container.start

```

Calling the 'start' method of an instantiated RedisContainer will connect to
the Redis database and begin polling for inbound messages.

## Installation

Add this line to your application's Gemfile:

    gem 'barrister-redis'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install barrister-redis

## Contributing

1. Fork it ( http://github.com/<my-github-username>/barrister-redis/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

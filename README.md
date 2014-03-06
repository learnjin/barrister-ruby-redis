# Barrister::Redis

A Redis server-container and transport for Barrister RPC.

## Before Getting Started

First, check out Barrister RPC here: http://barrister.bitmechanic.com

## Reference Implementation

For a working example of a Rails UI backed by services using the
RedisTransport and RedisContainer, see https://github.com/laser/ruby-micro-services-redis

## Usage

To instantiate a Redis transport, at a minimum you need the name of the list
that the client and server will be using as a message bus. If no database_url
is specified in the options hash, redis://localhost:6379 will be used as the
default.

```ruby

transport_a = Barrister::RedisTransport.new 'user_service'
transport_b = Barrister::RedisTransport.new 'user_service', database_url: ENV['OPEN_REDIS_URL']

```

Instantiating a Redis container is easy as well. By default, the container 
requires a path to the JSON output of the IDL to JSON conversion and an
instantiated handler whose name matches the name of an interface in the IDL.
By default, the RedisContainer will use the name of the JSON file for the
name of the list (e.g. './foo/user\_service.json' will result in the 
'user\_service' list).

```ruby

container_a = Barrister::RedisContainer.new './user_service.json', UserService.new
container_a.start

```

For more advanced users, additional options can be specified:

```ruby

opts = { database_url: ENV['OPEN_REDIS_URL'], list_name: 'some_list_name' }
container_b = Barrister::RedisContainer.new './user_service.json', [HandlerA.new, HandlerB.new], opts
container_b.start

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

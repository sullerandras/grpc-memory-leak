require 'grpc'

libdir = File.dirname(__FILE__) + '/lib/generators'
$LOAD_PATH.unshift(libdir) unless $LOAD_PATH.include?(libdir)

require 'helloworld_services_pb'

stub = Helloworld::Greeter::Stub.new('localhost:50051', :this_channel_is_insecure)
1_000_000.times do |i|
  req = Helloworld::HelloRequest.new(name: 'Joe')
  puts("request: req=#{req.inspect}") if i % 10_000 == 0
  resp = stub.say_hello(req)
  puts("Answer: #{resp.inspect}") if i % 10_000 == 0
end

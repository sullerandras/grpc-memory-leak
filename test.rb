# frozen_string_literal: true

require 'grpc'
require 'json'

STDOUT.sync = true

libdir = File.dirname(__FILE__) + '/lib/generators'
$LOAD_PATH.unshift(libdir) unless $LOAD_PATH.include?(libdir)

require 'helloworld_services_pb'

if ENV['JEMALLOC_STATS']
  puts 'JEMALLOC_STATS enabled'

  require 'jemal'

  if Jemal.jemalloc_builtin?
    puts 'jemalloc found'
    Thread.new do
      begin
        first = true

        loop do
          sleep 5
          GC.start # try to remove the noise in the data
          stats = Jemal.stats
          stats[:ts] = Time.now.utc.to_i

          File.open(File.dirname(__FILE__) + '/log/jemalloc.log', first ? 'w' : 'a') do |f|
            f.puts stats.to_json
          end

          first = false
        end
      rescue => ex
        puts "error: #{ex.inspect}\n\t#{ex.backtrace.join("\n\t")}"
      ensure
        puts 'jemalloc thread finished'
      end
    end
  end
end

puts '======> starting stress test'
stub = Helloworld::Greeter::Stub.new('192.168.1.2:50051', :this_channel_is_insecure)
10_000_000.times do |i|
  req = Helloworld::HelloRequest.new(name: 'Joe')
  puts("request: req=#{req.inspect}") if i % 10_000 == 0
  resp = stub.say_hello(req)
  puts("Answer: #{resp.inspect}") if i % 10_000 == 0
end

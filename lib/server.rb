require 'socket'

socket = TCPServer.new 2000
loop do
  Thread.start(socket.accept) do |client|
    puts 'connection recieved'
    request = client.gets
    p request
    client.puts "Hello #{request} Time is #{Time.now}"
    client.close
  end
end
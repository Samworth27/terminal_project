require 'socket'        # Sockets are in standard library
require 'tty-prompt'

hostname = 'localhost'
port = 2000

def fetch(hostname = 'localhost', port = 2000)
  socket = TCPSocket.open(hostname, port)
  socket.puts 'next'
  puts 'req sent'

  while line = socket.gets     # Read lines from the socket
    puts line       # And print with platform line terminator
  end
  socket.close                 # Close the socket when done
end

def add_test(hostname = 'localhost', port = 2000)
  socket = TCPSocket.open(hostname, port)
  socket.puts 'add-test'
  puts 'req sent'
  if sockets.gets.chomp == 'send'
    
  socket.close                 # Close the socket when done
end


fetch
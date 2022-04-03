module QueueClient
  def run_client(test=nil)
    rand(0..1).zero? ? client_fetch : client_add(test)
  end

  def client_fetch(hostname = 'localhost', port = 2000)
    socket = TCPSocket.open(hostname, port)
    socket.puts 'next'
    puts 'req sent'

    while line = socket.gets     # Read lines from the socket
      puts line       # And print with platform line terminator
    end
    socket.close                 # Close the socket when done
  end

  def client_add(testing, hostname = 'localhost', port = 2000 )
    socket = TCPSocket.open(hostname, port)
    socket.puts 'add-test'
    puts 'req sent'
    id = socket.gets.chomp
    puts 'server ready to accept'
    item = Item.new(@database,id,testing)
    puts item.personal
    response = Oj.dump(item)
    socket.puts response
    socket.close                 # Close the socket when done
  end
end
module QueueServer
  def run_server
    count = 0
    socket = TCPServer.new 2000
    puts 'Server Starting'
    begin
      loop do
        Thread.start(socket.accept) do |client|
          puts 'connection recieved'
          request = client.gets.chomp
          case request
          when 'next'
            puts 'Client requesting next item'
            response = next_item 
            client.puts response
          when 'add-test'
            puts "Client wants to add a test item. ID given: #{count}"
            client.puts count
            item = client.gets.chomp
            item = Oj.load(item)
            add_item(item)
            count += 1
          end
          client.close
        end
        p @queue.map {|item| item.id}
      end
    rescue
      puts "Server Ended"
    end
  end
end
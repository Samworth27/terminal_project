# frozen_string_literal: true

# Load all children
Dir.glob(File.expand_path("../#{File.basename(__FILE__, ".*")}/*.rb", __FILE__)).each { |file| require_relative "#{File.basename(__FILE__, ".*")}/#{File.basename(file)}"}

require 'tty-prompt'

module QueueClient
  def run_client(test=nil)
    prompt = TTY::Prompt.new
    loop do
      clear_screen
      case prompt.select("What would you like to do", [{value: :add, name: 'Add a new patient'}, {value: :next, name: 'Select the next patient'}, {value: :exit, name: 'Exit'}])
      when :add
        client_add(test)
      when :next
        client_fetch
        #add to local queue?
        prompt.keypress("Press any key to continue")
      else
        break
      end
    end
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
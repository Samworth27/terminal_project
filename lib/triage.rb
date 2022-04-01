# frozen_string_literal: true

# Load all children
Dir.glob(File.expand_path("../#{File.basename(__FILE__, ".*")}/*.rb", __FILE__)).each { |file| require_relative "#{File.basename(__FILE__, ".*")}/#{File.basename(file)}"}



if ARGV.include?('--admin')
  access = :admin
else
  access = :user
end

queue = QueueObject.new('main', 'main queue', Symptoms.new(access))


prompt = TTY::Prompt.new

loop do
  print `clear`
  case prompt.select("What would you like to do \n",[
    {value: :add, name: "Add a patient"},
    {value: :next, name: 'Get next patient'}])
  when :add
    queue.add_item
    puts "+"*80
    puts queue.queue
    puts '+' * 80
  when :next
    puts "-"*80
    puts "Request item"
    puts queue.next_item
    puts "-"*80
  end
  prompt.keypress("Press any key to continue")
end

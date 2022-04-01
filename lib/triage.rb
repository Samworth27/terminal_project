# Load all children
Dir.glob(File.expand_path("../#{File.basename(__FILE__, ".*")}/*.rb", __FILE__)).each { |file| require_relative "#{File.basename(__FILE__, ".*")}/#{File.basename(file)}"}



if ARGV.include?('--admin')
  access = :admin
else
  access = :user
end

queue = QueueObject.new('main', 'main queue', Symptoms.new(access))


queue.add_item
puts queue
queue.add_item
puts queue


# frozen_string_literal: true

# Load all children
Dir.glob(File.expand_path("../#{File.basename(__FILE__, ".*")}/*.rb", __FILE__)).each { |file| require_relative "#{File.basename(__FILE__, ".*")}/#{File.basename(file)}"}

# Fetch arguments from command line
# If the argument '--admin' has been passed in set access level to :admin
if ARGV.include?('--admin')
  access = :admin
else
  access = :user
end
if ARGV.include?('--testing')
  testing = true
else
  testing = nil
end

# Init the queue
queue = DynamicQueue.new('main', 'main queue', Symptoms.new(access))


# Run Client
if ARGV.include?('--server')
  queue.run_server
elsif ARGV.include?('--client')
  queue.run_client(testing)
else
  queue.run_local(testing)
end

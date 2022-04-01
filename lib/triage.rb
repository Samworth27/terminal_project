# frozen_string_literal: true

# Load all children
Dir.glob(File.expand_path("../#{File.basename(__FILE__, ".*")}/*.rb", __FILE__)).each { |file| require_relative "#{File.basename(__FILE__, ".*")}/#{File.basename(file)}"}

require 'tty-prompt'
# Fetch arguments from command line
# If the argument '--admin' has been passed in set access level to :admin
if ARGV.include?('--admin')
  access = :admin
else
  access = :user
end

# Init the queue
queue = QueueObject.new('main', 'main queue', Symptoms.new(access))

# Run Client
queue.run

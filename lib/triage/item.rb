# frozen_string_literal: true

# Load all children
Dir.glob(File.expand_path("../#{File.basename(__FILE__, ".*")}/*.rb", __FILE__)).each { |file| require_relative "#{File.basename(__FILE__, ".*")}/#{File.basename(file)}"}


# # Defines function for inbuilt instance counter
# module InstanceCounter
#   # Inbuilt Counter
#   def self.count
#     @count
#   end

#   def self.count=(value)
#     @count = value
#   end
# end

# Item Class
class Item
  @count = 0
  attr_reader :id, :fname, :lname, :flags, :time_presented
  attr_accessor :notes, :priority

  def initialize(name)
    @id = self.class.count
    self.class.count += 1
    @fname = name[:fname]
    @lname = name[:lname]
    @time_presented = Time.new
    @flags = 0
    @notes = []
    @priority = 3
    # puts "Item init with id #{@id} @ #{@time_presented}"
  end

  # Inbuilt Counter
  def self.count
    @count
  end

  def self.count=(value)
    @count = value
  end

  def exist?
    true
  end
end

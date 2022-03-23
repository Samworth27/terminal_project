# frozen_string_literal: true

# Item Class
class QueueItem
  @count = 0
  attr_reader :id, :fname, :lname, :symptom_flags, :time_presented
  attr_accessor :notes, :priority

  def initialize(name)
    @id = self.class.count
    self.class.count += 1
    @fname = name[:fname]
    @lname = name[:lname]
    @time_presented = Time.new
    @symptom_flags = 0
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

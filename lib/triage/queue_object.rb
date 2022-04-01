# frozen_string_literal: true

# Load all children
Dir.glob(File.expand_path("../#{File.basename(__FILE__, ".*")}/*.rb", __FILE__)).each { |file| require_relative "#{File.basename(__FILE__, ".*")}/#{File.basename(file)}"}

# Custom Error Class
class InvalidInput < StandardError
end

# QueueObject Class
class QueueObject
  attr_reader :name, :description, :queue

  def initialize(name, description, database)
    @name = name
    @description = description
    @queue = []
    @database = database
    Flags.new(0,@database.codes)
  end

  def exist?
    true
  end

  def queue
    @queue.each_with_index.map { |item, i| "Position in Queue: #{i}\n #{item}\n"}
  end

  def add_item
    @queue.append(Item.new(@database))
  end

  def view_item(id)
    raise(InvalidInput, "inputed #{id.class} not Integer") if id.class != Integer

    @queue.select { |item| item[:id] = id}
  end
end
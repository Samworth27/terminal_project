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

  def queue_test
    @queue.each_with_index.map { |item, i| "Position in Queue: #{i}\n #{item.to_s_test}\n"}
  end

  def add_item
    @queue.append(Item.new(@database))
  end

  def add_item_test(pri)
    item = Item.new(@database, pri)
    begin
      @queue.insert(@queue.find_index{|x| x.priority>pri},item)
    rescue
      @queue.append(item)
    end
  end

  def view_item(id)
    raise(InvalidInput, "inputed #{id.class} not Integer") if id.class != Integer
    @queue.select { |item| item[:id] = id}
  end

  def next_item
    @queue.shift
  end

  def next_item_test
    @queue.size > 0 ? @queue.shift.to_s_test : 'No items in queue'
  end
end
# frozen_string_literal: true

# Load all children
Dir.glob(File.expand_path("../#{File.basename(__FILE__, ".*")}/*.rb", __FILE__)).each { |file| require_relative "#{File.basename(__FILE__, ".*")}/#{File.basename(file)}"}

# Custom Error Class
class InvalidInput < StandardError
end

# QueueObject Class
# This object stores information relating to a specific queue.
# Items can be assigned to the queue with a priority and the next 
# item can be requested
class QueueObject

  #@param name [String]
  #@param description [String]
  attr_reader :name, :description

  # @param name [String] A name for the queue
  # @param description [String] A description of the queue
  # @param database [Object] A symptoms database object. Not actually a database
  #   but is used to access the database
  # @return [Object] The initilised queue object
  def initialize(name, description, database)
    @name = name
    @description = description
    @queue = []
    @database = database
    Flags.new(0,@database.codes)
  end

  def queue
    @queue.each_with_index.map { |item, i| "Position in Queue: #{i}\n #{item}\n"}
  end

  def add_item
      item = Item.new(@database)
    begin
      @queue.insert(@queue.find_index{|x| x.priority>item.priority},item)
    rescue
      @queue.append(item)
    end
  end

  def view_item(id)
    raise(InvalidInput, "inputed #{id.class} not Integer") if id.class != Integer
    @queue.select { |item| item[:id] = id}
  end

  def next_item
    @queue.size > 0 ? @queue.shift : 'No items in queue'
  end

  def run
    prompt = TTY::Prompt.new
    loop do
      clear_screen
      case prompt.select("What would you like to do \n",[
        {value: :add, name: "Add a patient"},
        {value: :next, name: 'Get next patient'}])
      when :add
        add_item
        puts "+"*80
        puts queue
        puts '+' * 80
      when :next
        puts "-"*80
        puts "Request item"
        puts next_item
        puts "-"*80
      end
      prompt.keypress("Press any key to continue")
    end
  end

  def exist?
    true
  end

  private

  def add_item_test(pri)
    item = Item.new(@database, pri)
    begin
      @queue.insert(@queue.find_index{|x| x.priority>pri},item)
    rescue
      @queue.append(item)
    end
  end

  def next_item_test
    @queue.size > 0 ? @queue.shift.to_s_test : 'No items in queue'
  end

  def queue_test
    @queue.each_with_index.map { |item, i| "Position in Queue: #{i}\n #{item.to_s_test}\n"}
  end





end
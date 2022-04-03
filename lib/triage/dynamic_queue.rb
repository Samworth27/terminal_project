# frozen_string_literal: true

# Load all children
Dir.glob(File.expand_path("../#{File.basename(__FILE__, ".*")}/*.rb", __FILE__)).each { |file| require_relative "#{File.basename(__FILE__, ".*")}/#{File.basename(file)}"}

# DynamicQueue Class
# This object stores information relating to a specific queue.
# Items can be assigned to the queue with a priority and the next 
# item can be requested
class DynamicQueue

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

  def add_item(test=nil)
    item = Item.new(@database, test)
    begin
      @queue.insert(@queue.find_index{|x| x.priority>item.priority},item)
    rescue
      @queue.append(item)
    end
  end

  def view_item(id)
    raise(InvalidInput, "inputed #{id.class} not Integer") if id.class != Integer
    @queue.select { |item| item.id == id}[0]
  end

  def next_item
    @queue.size > 0 ? @queue.shift : 'No item in queue'
  end

  def queue
    @queue.each_with_index.map { |item, i| "Position in DynamicQueue: #{i}\n #{item}\n"}
  end

  def [] (index)
    @queue[index]
  end

  def size
    @queue.size
  end

  def exist?
    true
  end
end
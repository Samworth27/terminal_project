# frozen_string_literal: true

# Load all children
Dir.glob(File.expand_path("../#{File.basename(__FILE__, ".*")}/*.rb", __FILE__)).each { |file| require_relative "#{File.basename(__FILE__, ".*")}/#{File.basename(file)}"}

# Custom Error Class
class InvalidInput < StandardError
end

# QueueObject Class
class QueueObject
  attr_reader :name, :description, :queue

  def initialize(name, description)
    @name = name
    @description = description
    @queue = {}
  end

  def exist?
    true
  end

  def add_item(item)
    raise(InvalidInput, "inputted #{item.class} not Item") if item.class != Item

    @queue[item.id] = item
  end

  def view_item(id)
    raise(InvalidInput, "inputeed #{id.class} not Integer") if id.class != Integer

    @queue[id]
  end
end
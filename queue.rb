# frozen_string_literal: true

# Queue Class
class Queue
  attr_reader :name, :description
  attr_accessor :queue

  def initialize(name, description)
    @name = name
    @description = description
    @queue = []
  end

  def exist?
    true
  end
end

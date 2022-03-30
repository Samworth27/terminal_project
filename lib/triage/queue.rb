# frozen_string_literal: true

# Load all children
Dir.glob(File.expand_path("../#{File.basename(__FILE__, ".*")}/*.rb", __FILE__)).each { |file| require_relative "#{File.basename(__FILE__, ".*")}/#{File.basename(file)}"}

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

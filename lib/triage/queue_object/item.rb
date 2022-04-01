# frozen_string_literal: true

# Load all children
Dir.glob(File.expand_path("../#{File.basename(__FILE__, ".*")}/*.rb", __FILE__)).each { |file| require_relative "#{File.basename(__FILE__, ".*")}/#{File.basename(file)}"}

require 'time'

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
  attr_reader :id, :personal, :flags, :time_presented
  attr_accessor :notes, :priority

  def initialize(database)
    @id = self.class.count
    self.class.count += 1
    @personal = Person.new
    @time_presented = Time.new
  end

  def set_priority
    prompt = TTY::Prompt.new
    @priority = prompt.select('Select a priority', [1,2,3])
  end

  def modify(database)
    prompt = TTY::Prompt.new
    # Prompt user for what they want to modify
    loop do
      print `clear`
      unless @priority == nil
        case prompt.select('What do you want to do?',[{value: :flags, name:"Symptoms & Diagnosis (ICPC)"},{value: :notes, name: "Add notes"}, {value: :priority, name: 'Set Priority'},{value: :cancel,name: "Complete"}])
        when :flags
          set_information(database)
        when :notes
          add_notes(prompt.multiline("Enter Patient Notes", show_help: :always))
        when :priority
          set_priority
        when :cancel
          puts 'item created'
          break
        end
      else
        set_priority
      end
    end
  end

  def to_s
    ["Surname, First Name: #{@lname}, #{@fname}",
    "ID: #{@id}",
    "Priority: #{@priority}",
    # "Flags-Raw: #{@flags}",
    'Symptoms/ Diagnosis:',
    Flags.new(@flags).active_flags.map { |item| "\t #{@database.fetch_name(item)}"},
    'Notes: ',
    notes_to_s].join("\n")
  end

  def notes_to_s
    @notes.map do |item| 
      "\t#{item[:time].httpdate}\n\t#{item[:text].join("\n\t")}"
    end.join("\n")
  end

  def set_information(database)
    @flags = Flags.new(@flags).set_flags
  end

  def add_notes(note)
    @notes.append({time: Time.new, text: note})
  end

  def self.archive
    # Move to storage item
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

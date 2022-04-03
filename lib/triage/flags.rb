# frozen_string_literal: true

# Load all children
Dir.glob(File.expand_path("../#{File.basename(__FILE__, ".*")}/*.rb", __FILE__)).each { |file| require_relative "#{File.basename(__FILE__, ".*")}/#{File.basename(file)}"}


# Custom binary flag data type

class Flags
  @flags = {}

  # @param value [Int] The existing value of bitwise flag mask to modify
  # @param flag_names [Array<String>] Only set this the first time you use it
  def initialize(value, flag_names = '')
    @value = value

    # Populate 8 flags for testing
    if flag_names == 'testing'
      flag_names = []
      1.upto(8).each { |i| flag_names.append("flag_#{i}".to_sym) }
    end

    # If no value is passed when creating the class get the class instance values for flag_name - This is normal behaviour
    flag_names = self.class.flags.keys if flag_names == ''

    # If this is the first time initilising the class, set the class values for the flags hash
    if self.class.flags == {}
      flag_names.each_with_index do |flag, index|
        flag_value = 0b1 << index
        self.class.flags[flag] = flag_value
      end
    end

    # Create an instance method for every value of flag from the Class insance variable `flag`
    # self.class.flags.each do |flag, flag_value|
    #   create_method(flag, flag_value)
    # end
  end

  # Allows user to set flag values
  def set_flags
    symptoms = Symptoms.new(:user)
    prompt = TTY::Prompt.new
    loop do
      flag = symptoms.get_code
      return @value if flag == :exit
      set_to = prompt.select(
        "Currently '#{flag?(flag)}' set to [true/ false]",
        [{value: true, name: 'True'},{value: false, name: "False"}])
      set_flag(flag, set_to)
    end
  end

  # Set a flag to either true or false
  def set_flag(name, value)
    raise(InvalidInput, "#{value} is not [true/false]") unless [true, false].include? value
    if value == true
      @value |= flag_value(name)
    elsif value == false
      @value &= (flag_value(name) ^ (2**self.class.flags.size - 1))
    end
  end

  def flag?(code)
    flag_active(@value, flag_value(code))
  end

  def active_flags
    return self.class.flags.filter {|k, v| flag_active(@value,v)}.keys
  end


  def flag_active(flags, item)
    !(flags & item).zero?
  end

  def flags
    self.class.flags
  end

  class << self
    attr_accessor :flags
  end

  def to_s
    "0b#{format('%08b', @value)}"
  end

  def to_i
    @value
  end

  def exists?
    true
  end

  def flag_value(code)
    self.class.flags[code]
  end
  
  # def create_method(name, value)
  #   # Returns true if the flag `name` is on
  #   define_singleton_method(name) do
  #     flag_active(@value, value)
  #   end

  #   # Input true or false to set flag
  #   define_singleton_method("#{name}_set") do |set|
  #     if set == true
  #       @value |= value
  #     elsif set == false
  #       @value &= (value ^ (2**self.class.flags.size - 1))
  #     end
  #   end
  # end
  
end
# Custom binary flag data type

def flag_active(flags, item)
  !(flags & item).zero?
end

def create_method(name, value)
  # Returns true if the flag `name` is on
  define_singleton_method(name) do
    # puts "@value: #{@value} \n value: #{value}"
    flag_active(@value, value)
  end

  # Input true or false to set flag
  define_singleton_method("#{name}_set") do |set|
    if set == true
      @value |= value
    elsif set == false
      @value &= (value ^ (2**self.class.flags.size - 1))
    end
  end
end

class Flags
  @flags = {}

  def initialize(flag_names = '')
    @value = 0b0000000

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
    self.class.flags.each do |flag, flag_value|
      create_method(flag, flag_value)
    end
  end

  def flags
    self.class.flags
  end

  class << self
    attr_reader :flags
  end

  class << self
    attr_writer :flags
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
end

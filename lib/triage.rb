# Load all children
Dir.glob(File.expand_path("../#{File.basename(__FILE__, ".*")}/*.rb", __FILE__)).each { |file| require_relative "#{File.basename(__FILE__, ".*")}/#{File.basename(file)}"}

if ARGV.include?('--admin')
  access = :admin
else
  access = :user
end

symptoms = Symptoms.new(access)
Flags.new(0,symptoms.codes)
# puts symptoms.browse
# puts symptoms.get_code
item = Item.new({fname: 'John', lname:'Smith'}, symptoms)
puts item
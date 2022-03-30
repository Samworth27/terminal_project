# Load all children
require_relative './triage/flags'
require_relative './triage/queue_object'
require_relative './triage/symptoms'
require_relative './triage/app_errors'

if ARGV.include?('--admin')
  access = :admin
else
  access = :user
end

flags = Flags.new(Symptoms.new(access).codes)

# def set_flags(flags_object)
#   symptoms = Symptoms.new(:user)
#   prompt = TTY::Prompt.new
#   loop do
#     print `clear`
#     puts "flags: #{flags_object} => #{flags_object.to_i} \n"
#     # puts "flag to set. #{flags_object.class.flags.keys.map{|i| i.to_s}} or [exit] to finish inputing"
#     # print '> '
#     flag = symptoms.get_code
#     return flags_object if flag == :exit
#     puts flags_object
#     set_to = prompt.select(
#       "Currently '#{flags_object.public_send(flag)}' set to [true/ false]",
#       [{value: true, name: 'True'},{value: false, name: "False"}])
#     flag += '_set'
#     flags_object.public_send(flag, set_to)
#   end
# end

puts  flags.set_flags
p flags.active_flags


# p (0b0001^0b1111).to_s(2)
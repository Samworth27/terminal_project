require_relative './lib/triage/flags'

Flags.new(['chest pain', 'fracture', 'hemorrhage','unconsciouse'])

bad_test = Flags.new([:bad_1, :bad_2, :bad_3])




def set_flags(flags_object)
  loop do
    print `clear`
    puts "flags: #{flags_object} => #{flags_object.to_i} \n"
    puts "flag to set. #{flags_object.class.flags.keys.map{|i| i.to_s}} or [exit] to finish inputing"
    print '> '
    flag = gets.chomp
    break if flag == 'exit'
    puts "Currently '#{flags_object.public_send(flag)}' set to [true/ false]"
    print '> '
    flag += '_set'
    set_to = gets.chomp == 'true'
    flags_object.public_send(flag, set_to)
  end
end

set_flags(Flags.new)


# p (0b0001^0b1111).to_s(2)
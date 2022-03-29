# frozen_string_literal: true

require_relative 'symptoms/symptoms_db'
require 'tty-prompt'
require 'rainbow'
require 'tty-box'
require 'tty-screen'
# Init database
symptoms = SymptomsDatabase.new
prompt = TTY::Prompt.new(active_color: :inverse)

#Main BLock
print `clear`
display = symptoms.fetch_pretty('root')

loop do
  if display[:children].size.zero?
    # End of branch options
    choices = [
      {value: 'select', name: 'Select option'},
      {value: 'ruberic', name: 'Fetch ruberic'},
      {value: 'return', name: 'Return to search'}
    ]
    case prompt.select("Choose an option", choices)
  
    when 'select'
      puts display
      return display
    when 'ruberic'
      puts 'Fetching ruberic'
      prompt.keypress("Press any key to continue")
      print `clear`
    else
      input = 'parent'
    end
  end

  choices = display[:children]

  choices.append([
    {value: 'parent', name: Rainbow('>> Return to Previous').red},
    {value: 'root', name: Rainbow('>> Return to Start').red}
    ]
  ) unless display[:id] == '#'
  choices.append({value:'exit', name: Rainbow('>> Exit without selecting an option').red})
  
  input = prompt.select("Choose an item, return to the previous item, restart or exit",choices, filter: true) unless input == 'parent'

  input = display[:parent] if input == 'parent'
  break if input == 'exit'

  print `clear`
  display = symptoms.fetch_pretty(input)
  
  if TTY::Screen.height > 16
    box = TTY::Box.frame(width: TTY::Screen.width, height: TTY::Screen.height/2, padding:5) do
      display[:string]
    end
    print box
  else
    puts display[:string]
  end
end

# def try
#   yield if block_given?
# rescue AppError => e
#   e
# end

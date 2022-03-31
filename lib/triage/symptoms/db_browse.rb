# frozen_string_literal: true

# Load all children
Dir.glob(File.expand_path("../#{File.basename(__FILE__, ".*")}/*.rb", __FILE__)).each { |file| require_relative "#{File.basename(__FILE__, ".*")}/#{File.basename(file)}"}

require 'tty-prompt'
require 'rainbow'
require 'tty-box'
require 'tty-screen'

module DBBRowse
  def browse
    prompt = TTY::Prompt.new(active_color: :inverse)
    print `clear`
    display = fetch_pretty('root')
    puts display[:string].render(:unicode, resize: true, height: 6, alignments: [:right, :left], column_widths: [15,TTY::Screen.width-15])

    loop do
      if display[:children].size.zero?
        # End of branch options
        choices = [
          {value: 'select', name: 'Select option'},
          {value: 'rubric', name: 'Fetch rubric', disabled: '(Feature not complete)'},
          {value: 'return', name: 'Return to search'}
        ]
        case prompt.select("Choose an option", choices)
      
        when 'select'
          return display[:code]
        when 'rubric'
          puts 'Fetching rubric'
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
      
      input = prompt.select("Choose an item, return to the previous item, restart or exit",choices, filter: true, per_page:(TTY::Screen.height-6)) unless input == 'parent'

      input = display[:parent] if input == 'parent'
      break if input == 'exit'

      print `clear`
      display = fetch_pretty(input)
      
      # box = TTY::Box.frame(width: TTY::Screen.width, height: 6) do
      puts display[:string].render(:unicode, resize: true, height: 6, alignments: [:right, :left],column_widths: [15,TTY::Screen.width-15])
      # end
      # print box
    end
  end
end
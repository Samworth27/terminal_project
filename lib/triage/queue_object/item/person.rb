# frozen_string_literal: true

# Load all children
Dir.glob(File.expand_path("../#{File.basename(__FILE__, ".*")}/*.rb", __FILE__)).each { |file| require_relative "#{File.basename(__FILE__, ".*")}/#{File.basename(file)}"}

require 'rainbow'

class Person

  def initialize
    @name = collect_name
    @dob = collect_dob
    @address = collect_address
    @number = collect_phone

  end

  def collect_name
    prompt = TTY::Prompt.new
    prompt.collect do
    key(:fname).ask("First Name:") { |p| p.validate(/^[a-z]+$/i)}
    key(:lname).ask("Last Name:") { |p| p.validate(/^[a-z]+$/i)}
    end
  end

  def collect_dob
    prompt = TTY::Prompt.new
    month_regex = /(^0?[1-9]$)|(^1[0-2]$)|^(?:Jan(?:uary)?|Feb(?:ruary)?|Mar(?:ch)?|Apr(?:il)?|May|Jun(?:e)?|Jul(?:y)?|Aug(?:ust)?|Sep(?:tember)?|Oct(?:ober)?|(Nov|Dec)(?:ember)?)$/i
    dob = {}
    dob[:year] = prompt.ask("Date of Birth: [yyyy]\nYear:", validate: /^\d{4}$/)
    dob[:month] = prompt.ask("Date of Birth: \nMonth:", validate: month_regex)
    dob[:day] = prompt.ask("Date of Birth:\nDay:", in: (1..31))
    Date.parse(dob.values.join('-'))
  end

  def collect_address
    prompt = TTY::Prompt.new
    prompt.collect do
      key(:unit).ask("Unit/ Appartment Number [optional]")
      key(:number).ask("Street Number:", required: true, validate: /^\d+$/)
      key(:street).ask("Street Name:", required: true)
      key(:suburb).ask("City/ Town/ Suburb: ", required: true)
      key(:postcode).ask("Post Code: [optional]", validate: /^$|^\d{4}$/)
    end
  end

  def collect_phone
    r = /^(?<prefix>(?<country>\+?61)?(?<area>((?(<country>)|0)[2378])|((?(<country>)|0)[45])))(?<number>\d{8})$/
    prompt = TTY::Prompt.new
    loop do
      number = prompt.ask("Contact Number", required: true) do |response|
        response.validate(/^[\+.\-\(\) \d]*$/)
        response.messages[:valid?] = Rainbow('Invalid Characters').red
      end
      number.gsub!(/[\+.\-\(\) ]/,'')
      number = number.match(r)
      unless number.nil?
        number = number.named_captures
        number['prefix'] = '+61' + number['area'][-1] if number['country'].nil? or number['country'] == '61'
        return number['prefix']+number['number']
      else
        prompt.error("Invalid Number")
      end
    end
  end
end

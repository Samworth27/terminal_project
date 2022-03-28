# frozen_string_literal: true

require_relative 'symptoms/symptoms_db'

# Init database
symptoms = SymptomsDatabase.new

puts 'Fetch fresh data [yes/no]'
symptoms.fetch_data if gets.chomp == 'yes'

puts 'Rebuild database [yes/no]'
symptoms.reload_database if gets.chomp == 'yes'

# begin
#   puts symptoms.fetch_by_id(9999)
#   puts symptoms.fetch_by_code('AAAA')
#   puts symptoms.fetch_by_id('root')
# rescue PStore::Error=>e
#   puts e
# end

def try
  yield if block_given?
rescue AppError => e
  e
end

['A', 'AS01', 'AAAA', '#', 1, 9999].each do |i|
  puts(try { symptoms.fetch_pretty(i) })
end

# test = Typhoeus::Request.new('https://browser.icpc-3.info/browse.php', params: { operation: 'getClasses', id: '#' })
# test.on_complete do |response|
#   if response.success?
#     puts 'Request complete'
#   else
#     raise StandardError
#   end
# end
# response = test.run
# p response.response_body

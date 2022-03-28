# frozen_string_literal: true


# Init database
symptoms = SymptomsDatabase.new

puts 'Fetch fresh data [yes/no]'
symptoms.fetch_data if gets.chomp == 'yes'

puts 'Rebuild database [yes/no]'
symptoms.reload_database if gets.chomp == 'yes'

puts symptoms.fetch_by_id(1)
puts symptoms.fetch_by_code('A')
puts symptoms.fetch_by_id('root')

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

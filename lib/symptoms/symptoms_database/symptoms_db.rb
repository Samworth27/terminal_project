require_relative './symptoms_database/db_build'
require_relative './symptoms_database/db_calls'

# Api Reference
# https://www.icpc-3.info/documents/extra/API-Calls.pdf

# Structure used to fetch and store information IRT the ICPC
# (Internation classification of Primary Care) using their own HTTP APIs
class SymptomsDatabase
  include DBBuild
  include DBCalls

  # No need for any arguments
  def initialize
    @size = 0
    @storage = PStore.new('./db/storage.pstore')
  end

  def to_s
    @storage.transaction do
      @size = @storage[:size]
    end
    "Database containing #{@size} items"
  end

  def reload_database
    json = File.open('./symptoms/symptoms.json')
    json = json.read
    json = JSON.parse(json, symbolize_names: true)
    build(json[0])
    print `clear`
  end
end

# frozen_string_literal: true

require 'pstore'
require_relative '../../app_errors'

# Contains calls for pstore database
module DBCalls

  def pretty(content)
    content[:children].map! { |i| id_to_code(i) } if content[:children].is_a? Array
    "
    Code:         #{content[:code]}
    Description:  #{content[:text]}
    Children:     #{content[:children]}
    "
  end

  def fetch_pretty(input)
    return pretty(fetch_by_id(input)) if valid?(input)

    raise DBInputError, "#{input} is not a valid input"
  end

  # private

  def valid?(id)
    fetch_by_id(id)
    true
  rescue PStore::Error
    false
  end

  def id_to_code(id)
    false if id == false
    fetch_by_id(id)[:code]
  end

  def fetch_by_id(id)
    # Check for valid input
    @storage.transaction(true) do
      return @storage.fetch(id)
    rescue PStore::Error => e
      raise PStore::Error, "fetch_by_id(#{id}) failed"
    end
  end
  
  def fetch_by_code(code)
    # Check for valid input
    @storage.transaction(true) do
      return @storage.fetch(code)
    rescue PStore::Error => e
      raise PStore::Error, "fetch_by_code(#{code}) failed"
    end
  end
end

# frozen_string_literal: true

require 'pstore'

# Contains calls for pstore database
module DBCalls
  def fetch_by_id(id)
    @storage.transaction(true) do
      return @storage[id]
    end
  end
  
  def fetch_by_code(code)
    @storage.transaction(true) do
      return @storage[code]
    end
  end
end

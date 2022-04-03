# frozen_literal_string: true

# Load app_errors.rb here to include when testing without requiring additional
# `require` in spec file
require_relative 'app_errors'

def clear_screen
  print `clear`
end


# frozen_string_literal: true

# Load all children
Dir.glob(File.expand_path("../#{File.basename(__FILE__, ".*")}/*.rb", __FILE__)).each { |file| require_relative "#{File.basename(__FILE__, ".*")}/#{File.basename(file)}"}


require 'pstore'
require 'rainbow'
require 'tty-table'


# Contains calls for pstore database
module DBCalls
  
  def colour_child(child)
    child = fetch_by_id(child)
    text = "#{child[:text]} -- #{child[:type]}"
    case child[:type]
    when 'chapter', 'component', 'subComponent', 'regionalChapter', 'regionalComponent', 'extensionComponent', 'extension', 'attribute'
      name = Rainbow(text).indianred
    when 'contactReason', 'context'
      name = Rainbow(text).green
    when 'trauma', 'neoplasm', 'infection', 'otherDiagnosis', 'congenital', 'clinicalFinding', 'category'
      name = Rainbow(text).magenta
    when 'symptom', 'complaint'
      name = Rainbow(text).yellow
    when 'process', 'extensionCode', 'attributeCode'
      name = Rainbow(text).cyan
    else
      name = text
    end

    {value: child[:id], code: child[:code],name: name}

  end

  def pretty(content)
    content[:children] = (content[:children].is_a? Array) ? (content[:children].map { |i| colour_child(i)}) : []
    content[:string] = TTY::Table.new([
      ['Code  ', '  '+content[:code]],
      :separator,
      ['Description  ', '  '+content[:text]]
      ])
    content
  end

  def fetch_parent(input)
    fetch_by_id(input)[:parent]
  end 

  def fetch_pretty(input)
    return pretty(fetch_by_id(input)) if valid?(input)

    raise DBInputError, "#{input} is not a valid input"
  end

  def end_of_branch?(id)
    false if id == ''
    fetch_by_id(id)[:children].size.zero?
  end

  # private
  def fetch_name(id)
    fetch_by_id(id)[:text]
  end

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
      content =  @storage.fetch(id)
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

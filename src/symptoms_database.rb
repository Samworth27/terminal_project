# frozen_string_literal: true

require 'net/http'
require 'json'
require 'pastel'
require 'pstore'
require 'tty-progressbar'

# Api Reference
# https://www.icpc-3.info/documents/extra/API-Calls.pdf

# Contains methods for fetching data from www.icpc-3.info
module ICPCFetch
  def fetch_data
    raw = return_all_children('nil')
    json = File.open('./symptoms/symptoms.json', 'w')
    json.write JSON.pretty_generate(raw)
    json.close
  end

  private

  def root_content
    [{
      'id': '#',
      'text': 'root',
      'state': nil,
      'type': 'root',
      'children': true
    }]
  end

  def return_children(item)
    item[:children].map { |child| child[:id] }
  end

  def fetch_json(id)
    # puts "\u251d#{"\u2500" * (3 * depth + 2)} Fetching #{id}"
    uri = URI("https://browser.icpc-3.info/browse.php?operation=getClasses&id=#{id}")
    content = Net::HTTP.get(uri)
    JSON.parse(content, symbolize_names: true)
  end

  def count_children(content)
    progress_size = content.filter { |item| item[:children] == true }.size
    count = content.filter { |item| item[:children] == false }.size
    [progress_size, count]
  end

  def recursive_bar(progress_size, progress)
    pastel = Pastel.new
    string = (pastel.green.inverse('-') * ((progress - 1).negative? ? 0 : progress)).to_s
    string += pastel.yellow.inverse('>')
    string + "#{pastel.on_red(' ') * (progress_size - (progress + 1))} \n"
  end

  def recursive_info(id, depth, progress_size, progress)
    if id == 'nil'
      'Fetching Symptoms'
    else
      string = "\u251d#{"\u2500" * (3 * depth + 2)} "
      string += "Fetching children of #{id == '#' ? 'root' : id} [#{progress + 1}/ #{progress_size}] "
      string + recursive_bar(progress_size, progress)
    end
  end

  def pfetch_data(id)
    if id == 'nil'
      [root_content, 1, 0]
    else
      # puts "\u251d#{"\u2500" * (3 * depth + 2)} Fetching #{id}"
      content = fetch_json(id)
      progress_size, count = count_children(content)
      [content, progress_size, count]
    end
  end

  def return_all_children(id, depth = -1, string = [], count = 0)
    count += 1
    content, progress_size, count = pfetch_data(id)
    print `clear`
    content.filter { |item| item[:children] == true }.each_with_index do |item, i|
      puts string.append recursive_info(id, depth, progress_size, i)
      item[:children], count = return_all_children(item[:id], depth + 1, string, count)
      string.pop
    end
    if content[0][:id] == '#'
      content[0][:size] = count
      content
    else
      [content, count]
    end
  end
end

# Structure used to fetch and store information IRT the ICPC
# (Internation classification of Primary Care) using their own HTTP APIs
class SymptomsDatabase
  include ICPCFetch

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
    build(json)
  end

  private

  def split_text(text)
    text = text.split
    [text.shift, text.join(' ')]
  end

  def build_init(size)
    print `clear`
    puts 'Storing to Database'
    @bar = TTY::ProgressBar.new(':bar [:current/ :total] :eta remaining', format_progressbar(size))
  end

  def format_progressbar(size)
    pastel = Pastel.new
    {
      total: size,
      width: 60,
      clear: true,
      incomplete: pastel.on_red(' '),
      complete: pastel.green.inverse('-'),
      head: pastel.yellow.inverse('>')
    }
  end

  def format_item(content, parent)
    content[:children] = content[:children].map { |i| i[:id] } unless content[:children] == false
    content.delete(:state)
    content[:code], content[:text] = split_text(content[:text])
    content[:parent] = parent
  end

  def store_item(content)
    @storage.transaction do
      @storage[content[:id]] = content
      @storage[:size] = @size
    end
  end

  # Fetches symptoms.json and updates storage.pstore
  def build(content, parent = nil)
    @size += 1
    # run build_init on first call of build
    build_init(content[:size]) if content[:id] == '#'

    # Recursive Call
    unless content[:children] == false
      content[:children].each do |item|
        build(item, content[:id])
      end
    end

    # Format and create pstore record
    format_item(content, parent)
    store_item(content)

    # Advance Progress bar
    @bar.advance
  end
end

# Init database
symptoms = SymptomsDatabase.new

puts 'Fetch fresh data [yes/no]'
symptoms.fetch_data if gets.chomp == 'yes'

puts 'Rebuild database [yes/no]'
symptoms.reload_database if gets.chomp == 'yes'

puts symptoms

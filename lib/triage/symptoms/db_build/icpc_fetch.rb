# frozen_string_literal: true

require 'json'
require 'rainbow'
require 'typhoeus'

# Contains methods for fetching data from www.icpc-3.info
module ICPCFetch
  def fetch_data
    raw = return_all_children('nil')
    json = File.open('./db/.cached/symptoms.json', 'w')
    json.write JSON.pretty_generate(raw)
    json.close
  rescue Interrupt => _e
    clear_screen
    puts 'Fetching new data cancelled'
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

  def fetch_json(id, depth)
    puts "\u251d#{"\u2500" * (3 * depth + 2)} Fetching #{id}"
    content = Typhoeus.get('https://browser.icpc-3.info/browse.php', params: { operation: 'getClasses', id: id })
    content = JSON.parse(content.response_body, symbolize_names: true)
    return content[0][:children] if id == '#'

    content
  end

  def recursive_bar(progress_size, progress)
    string = (Rainbow('-').green.inverse * ((progress - 1).negative? ? 0 : progress)).to_s
    string += Rainbow('>').yellow.inverse
    string + "#{Rainbow(' ').red.inverse * (progress_size - (progress + 1))} \n"
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

  def count_children(content)
    total = content.size
    true_values = content.filter { |item| item[:children] == true }.size
    false_values = total - true_values
    [true_values, false_values]
  end

  def pfetch_data(id, depth)
    if id == 'nil'
      [root_content, 1, 0]
    else
      content = fetch_json(id, depth)
      progress_size, count = count_children(content)
      [content, progress_size, count]
    end
  end

  def return_children_display(id, depth, progress, string, count)
    puts string.append recursive_info(id[0], depth, progress[0], progress[1])
    item, count = return_all_children(id[1], depth + 1, string, count)
    string.pop
    [item, count]
  end

  def return_all_children(id, depth = -1, string = [], count = 0)
    count += 1
    content, progress_size, count2 = pfetch_data(id, depth)
    count += count2
    content.filter { |item| item[:children] == true }.each_with_index do |item, i|
      clear_screen
      item[:children], count = return_children_display([id, item[:id]], depth, [progress_size, i], string,
                                                       count)
    end

    if content[0][:id] == '#'
      content[0][:size] = count
      content
    else
      [content, count]
    end
  end

  def fetch_search(terms)
    puts "Fetching search results for '#{terms}'"
    content = Typhoeus.get('https://browser.icpc-3.info/browse.php', params: { operation: 'search1', str: terms })
    content = JSON.parse(content.response_body, symbolize_names: true)
  end

end

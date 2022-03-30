# frozen_string_literal: true

# Load all children
Dir.glob(File.expand_path("../#{File.basename(__FILE__, ".*")}/*.rb", __FILE__)).each { |file| require_relative "#{File.basename(__FILE__, ".*")}/#{File.basename(file)}"}


require 'pstore'
require 'tty-progressbar'

# Functions required to build database
module DBBuild
  include ICPCFetch

  private


  def split_text(text)
    text = text.split
    [text.shift, text.join(' ')]
  end

  def build_init(size)
    print `clear`
    puts 'Storing to Database'
    @bar = TTY::ProgressBar.new(':bar [:current/ :total] :eta remaining', format_progressbar(size))
    @codes = []
    @size = 0
  end

  def format_progressbar(size)
    {
      total: size,
      width: 60,
      clear: true,
      incomplete: Rainbow(' ').red.inverse,
      complete: Rainbow('-').green.inverse,
      head: Rainbow('>').yellow.inverse
    }
  end

  def format_item(content, parent)
    content[:children] = content[:children].map! { |i| i[:id] } unless content[:children] == false
    content.delete(:state)
    content[:code], content[:text] = split_text(content[:text])
    content[:parent] = parent
    content
  end

  def store_item(content)
    @storage.transaction do
      # content[:children].map! { |child| @storage[child] } unless content[:children] == false
      @storage[content[:id]] = content
      @storage[content[:code]] = @storage[content[:id]]
    end
  end

  def store_final
    @storage.transaction do
      @storage[:size] = @size
      @storage[:codes] = @codes
      puts @codes[0..10]
    end
  end

  # Fetches symptoms.json and updates storage.pstore
  def build(content, parent = nil)
    # run build_init on first call of build
    build_init(content[:size]) if content[:id] == '#'
    @size += 1

    # Recursive Call
    unless content[:children] == false
      content[:children].each do |item|
        build(item, content[:id])
      end
    end

    # Format and create pstore record
    content = format_item(content, parent)
    store_item(content)

    @codes.append(content[:code]) if content[:children] == false
    # Advance Progress bar
    @bar.advance
    store_final if content[:id] == '#'
  end
end

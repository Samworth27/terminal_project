# frozen_string_literal: true

require 'pstore'
require 'tty-progressbar'
require 'pastel'

require_relative './icpc_fetch/icpc_fetch'
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
      @storage[content[:code]] = @storage[content[:id]]
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

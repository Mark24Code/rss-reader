# frozen_string_literal: true

require_relative './patch'
require_relative './utils'
require 'rss'
require 'open-uri'
require 'async'

# RSS Channel class
class RSSChannel
  attr_accessor :feed

  def initialize(channel_url)
    @channel_url = channel_url
    @feed = nil

    fetch_channel
  end

  def fetch_channel
    URI.open(@channel_url) do |rss|
      @feed = RSS::Parser.parse(rss)
      # Utils.display_by_reader(@feed)
    end
  rescue OpenURI::HTTPError
    puts "[Request Error] #{@channel_url}"
  end

  def items
    items = []
    @feed.items.each_with_index do |item, index|
      items.push "#{"[#{index}]".green} #{Utils.url_text(item.title.to_s.dark_green, item.link)}"
    end
    items
  end

  def open_url_by_index(index)
    item = @feed.items[index]
    Utils.open_url(item.link)
  end

  def description_by_index(index)
    item = @feed.items[index]
    item.description
  end

  def content_by_index(index)
    Utils.html_to_text(description_by_index(index))
  end
end

# RSS Manager: Core Channel Manager Class
class RSSManager
  attr_accessor :channels, :current_channel_index

  def initialize
    config_file = File.join(ENV['HOME'], 'subscribe-rss.list')
    unless File.exist?(config_file)
      File.open(config_file, 'w') do |f|
        f << 'https://www.ruby-lang.org/en/feeds/news.rss'
      end
    end
    @channel_config_path = config_file
    @channel_urls = []
    @channels = []

    init_pipeline
  end

  def load_channel_urls
    channel_lines = File.open(@channel_config_path).readlines.map(&:strip)
    @channel_urls = channel_lines.filter do |x|
      x != '' && x.index('#') != 0
    end
    @channel_urls
  end

  def init_channels
    @channel_urls.each do |channel_url|
      @channels.push(RSSChannel.new(channel_url))
    end
  end

  def update_channels
    time_start = Time.now
    async_fetch
    time_end = Time.now
    puts "use: #{time_end - time_start}"
  end

  def sync_fetch
    # use: 6.022412
    @channels.each(&:fetch_channel)
  end

  def async_fetch
    # use: 2.854694
    Async do |task|
      @channels.each do |ch|
        task.async do
          ch.fetch_channel
        end
      end
    end
  end

  def init_pipeline
    load_channel_urls
    init_channels
    update_channels
  end

  def channel_titles
    titles = []
    @channels.each_with_index do |x, index|
      titles.push "#{"[#{index}]".green} #{x.feed.channel.title.to_s.blue} (#{x.feed.channel.items.length}) \n"
    end
    titles
  end

  def channel_title_by_index(channel_index)
    channel = @channels[channel_index]
    channel.feed.channel.title
  end

  def channel_by_index(channel_index)
    @channels[channel_index]
  end

  def channel_items(channel_index = 0)
    @channels[channel_index].items
  end
end

# rss_atom = RSSChannel.new('https://www.ruby-lang.org/en/feeds/news.rss')
# rss_atom.open_url_by_index(1)
# puts rss_atom.content_by_index(1)
#
# m = RSSManager.new
# puts m.channel_titles
# first = m.channel_by_index(1)
# puts first.items

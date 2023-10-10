#!/usr/bin/env ruby
# frozen_string_literal: true

require_relative './core'
require 'readline'

LIST = %w[
  help
  clear
  quit
  exit
  update
  reset
  channel
].sort

HELP_DOC = <<~HELP
  Help:
    help/h:    \t print help message
    clear/c:   \t clear screen
    quit/exit: \t quit
    exit:      \t quit
    update:    \t update all channel data
    reset/r:   \t channel list
    q:         \t quit current view

  Config:
    ~/subscribe-rss.list

HELP
comp = proc { |s| LIST.grep(/^#{Regexp.escape(s)}/) }
Readline.completion_append_character = ' '
Readline.completion_proc = comp

# RSS Client
class RssClient
  # rubocop:disable Metrics/MethodLength,Metrics/CyclomaticComplexity,Metrics/AbcSize,Metrics/BlockLength,Metrics/PerceivedComplexity
  def initialize
    @rss = nil
    @channel_index = -1
    @item_index = -1
    @debug = false
    init_rss
  end

  def init_rss
    puts 'RSS Reader'.green
    puts 'loading....'.green
    @rss = RSSManager.new
    system('clear')
    render
  end

  def render
    # TODO: index check & catch
    if @channel_index == -1 && @item_index == -1
      # render channels list
      puts '[RSS Reader]'.blue
      puts '----'
      puts @rss.channel_titles
    elsif @channel_index >= 0 && @item_index == -1
      # render channel item list
      puts "[Channel] #{@rss.channel_title_by_index(@channel_index)}".blue
      puts '----'
      puts @rss.channel_items(@channel_index)
    elsif @channel_index >= 0 && @item_index >= 0
      # render item content
      channel = @rss.channels[@channel_index]
      content = channel.content_by_index(@item_index)
      Utils.display_by_reader(content)
      @item_index = -1
    end
  end

  def reset_index
    @channel_index = -1
    @item_index = -1
  end

  def back_index
    reset_index
  end

  def print_index
    return unless @debug

    puts "@channel_index: #{@channel_index}"
    puts "@item_index: #{@item_index}"
  end

  def update_channels
    puts 'Updating channels ... '.green
    @rss.update_channels
    puts "Updated #{Time.now}".green
  end

  def run
    loop do
      line = Readline.readline('> ', true)
      break if line.nil? || line == 'quit'

      line = line.strip
      case line
      when 'quit', 'exit'
        exit 0
      when 'h', 'help'
        puts HELP_DOC
      when /(\d+)/
        index = ::Regexp.last_match(1)
        index = index.strip.to_i
        if @channel_index >= 0
          @item_index = index if index >= 0 && index < @rss.channels[@channel_index].items.length
        elsif index >= 0 && index < @rss.channels.length
          @channel_index = index
        end
        print_index
        render
      when 'c', 'clear'
        puts 'clear channel'
        system('clear')
        print_index
        render
      when 'r', 'reset'
        puts 'reset channel'
        reset_index
        print_index
        render
      when 'q'
        back_index
        print_index
        system('clear')
        render
      when 'update'
        update_channels
        print_index
        render
      else
        # do nothing
        print_index
        puts 'nothing happened...'
      end
    end
  end
end

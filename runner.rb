require_relative './rss.rb'

DEFAULT_FEEDS = ['https://kotaku.com/rss',
    'http://goodbeerhunting.com/sightlines?format=RSS',
    'http://feeds.feedburner.com/rockpapershotgun?format=xml',   
    'https://feeds.megaphone.fm/WWO3519750118',
    'https://feeds.fireside.fm/bibleinayear/rss',
    'https://feeds.simplecast.com/54nAGcIl',
    'https://rss.art19.com/apology-line']


def run_program
  puts '{Ruby Implemented RSS Reader}'
  puts '--> Enter a feed URL or select one of the default popular feeds {type "list" to see feeds, "help" for help}'
  puts '-------------------------------------'
  input = gets.chomp
  list_selection(input)
end

def list_selection(input)
  if input.to_i.to_s == input
    select_feed_from_input(DEFAULT_FEEDS[input.to_i - 1])
  elsif input == 'list'
    puts '-------------------------------------'
    list_feeds
  elsif input == 'exit'
    puts 'EXIT'
  elsif input.start_with?('http')
    select_feed_from_input(input)
  elsif input == 'help'
    list_help
    list_input
  else
    puts "Please enter a valid command\n\n"
    list_input
  end
end

def select_feed_from_input(input)
  new_feed = RSSFeed.new(input)
  new_feed.list_articles
  puts '-------------------------------------'
  articles_input(new_feed)
end

def list_feeds
  DEFAULT_FEEDS.each_with_index do |feed, index|
    puts "#{index + 1}. #{feed}"
  end
  puts '-------------------------------------'
  list_input
end

# parses input when selecting a feed
def list_input
  puts '--> Enter the feed number to view articles OR Enter a feed URL, {type "list" to see feeds}'
  input = gets.chomp
  list_selection(input)
end

# parses input when viewing a feed's articles
def articles_input(feed)
  puts '--> Select an article by article number to see more info, or type "help" for more commands'
  input = gets.chomp
  a_num = input.to_i
  if input.to_i.to_s == input
    display_article_info(feed.articles[a_num - 1], a_num, feed)
  elsif input.start_with? 'open' 
    feed.open_article_in_browser(feed.articles[input.split[-1].to_i - 1])
    feed.list_articles
    articles_input(feed)
  elsif input == 'list'
    list_input
  elsif input == 'help'
    articles_help
    articles_input(feed)
  elsif input == 'exit'
    puts 'EXIT'
  else
    puts "Please enter a valid command\n\n"
    articles_input(feed)
  end
end

def display_article_info(article, num, feed)
  puts '-------------------------------------'
  puts "Title: #{article.title}"
  puts "Published Date: #{article.pubDate}"
  puts "Author: #{article.dc_creator}"
  puts "\n"
  puts "Type \"a\" to return to the articles list, \"exit\" to exit the program"
  
 
  input = gets.chomp
  if input == "open"
    system "open #{article.link}"
    feed.list_articles
    articles_input(feed)
  elsif input == "a"
    feed.list_articles
    articles_input(feed)
  elsif input == "exit"
    puts "EXIT"
  end
end

def list_help
  puts "\n"
  puts '-------------------------------------'
  puts "help -> displays this menu"
  puts "exit -> exits the program\n\n"
end

def articles_help
  puts "\n"
  puts '-------------------------------------'
  puts "help -> displays this menu"
  puts "exit -> exits the program"
end
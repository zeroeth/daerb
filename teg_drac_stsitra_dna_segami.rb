require 'rubygems'
require 'bundler/setup'

require 'mechanize'
require 'pry'
require 'progressbar'

agent = Mechanize.new

require './daerb_drac'
include Daerb
cards = []

# Point to a results page from gatherer, in the format 'checklist'
page  = agent.get 'file:' + File.join(File.expand_path(File.dirname(__FILE__)), "card_artists_multiverse_id.html")
doc   = page.parser

rows = doc.css('tr.cardItem')

bar = ProgressBar.new 'Parse', rows.count
rows.each do |row|
  card = Card.new
  cards << card

  cols = row.css("td")

  card.set_number = cols[0].text
  card.name   = cols[1].text
  card.id     = cols[1].css('a').first['href'].match(/multiverseid=(\d*)/)[1]
  card.artist = cols[2].text
  card.color  = cols[3].text
  card.rarity = cols[4].text
  card.set    = cols[5].text

  bar.inc
end
bar.finish

binding.pry

# need to add scraper for http://magiccards.info/scans/en/avr/1.jpg
# because its higher res

bar = ProgressBar.new 'Images', rows.count
cards.each do |card|
  file_name = File.join('.', 'images', "#{card.id}.jpg")

  unless File.exists?(file_name)
    agent.get("http://gatherer.wizards.com/Handlers/Image.ashx?multiverseid=#{card.id}&type=card").save(file_name)
  end

  bar.inc
end
bar.finish

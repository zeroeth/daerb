require 'rubygems'
require 'bundler/setup'

require 'mechanize'
require 'csv'

require './daerb_drac'
include Daerb
cards = []
card = nil

agent = Mechanize.new

# Point to a results page from gatherer, in the format 'text spoiler'
page  = agent.get "file:" + File.join(File.expand_path(File.dirname(__FILE__)), "all_cards.html")
doc   = page.parser

rows = doc.css("tr")

rows.each do |row|
  cols = row.css("td")

  heading = cols.first.text.strip
  value   = cols.last.text.strip

  case heading
  when "Name:"
    card = Card.new
    cards << card

    card.name = value
  when "Cost:"
    card.cost = value
  when "Type:"
    card.type = value
  when "Pow/Tgh:"
    card.power_and_toughness = value
  when "Rules Text:"
    card.rules = value
  when "Set/Rarity:"
    card.sets_and_rarity = value
  when "Color:"
    card.color = value
  when "Loyalty:"
    card.loyalty = value
  when ""
  else
    raise "DUNNO WHAT (#{heading}) IS"
  end
end

# (power/toughness)
# rule\nrule\nrule
# set name rarity, set name rarity
# color/color/color

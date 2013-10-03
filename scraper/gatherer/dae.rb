require 'rubygems'
require 'bundler/setup'

require 'mechanize'
require 'pry'

agent = Mechanize.new

require './daerb_drac'
include Daerb
cards = []
card = nil

# Point to a results page from gatherer, in the format 'text spoiler'
# such as: http://gatherer.wizards.com/Pages/Search/Default.aspx?output=spoiler&method=text&action=advanced&type=%7c%5b%22Artifact%22%5d%7c%5b%22Basic%22%5d%7c%5b%22Creature%22%5d%7c%5b%22Enchantment%22%5d%7c%5b%22Instant%22%5d%7c%5b%22Land%22%5d%7c%5b%22Legendary%22%5d%7c%5b%22Ongoing%22%5d%7c%5b%22Phenomenon%22%5d%7c%5b%22Plane%22%5d%7c%5b%22Planeswalker%22%5d%7c%5b%22Scheme%22%5d%7c%5b%22Snow%22%5d%7c%5b%22Sorcery%22%5d%7c%5b%22Tribal%22%5d%7c%5b%22Vanguard%22%5d%7c%5b%22World%22%5d
page  = agent.get "file:" + File.join(File.expand_path(File.dirname(__FILE__)), "all_cards.html")
doc   = page.parser

rows = doc.css("tr")

rows.each do |row|
  cols = row.css("td")

  heading = cols.first.text.strip
  value   = cols.last.text.strip

  case heading
  when "Name:"
    card = GathererCard.new
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

puts cards.count

binding.pry

# (power/toughness)
# rule\nrule\nrule
# set name rarity, set name rarity
# color/color/color

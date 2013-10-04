# Information available
# * Name of set (useless)
# * Mini card 'row' information.
#   * Card Number
#   * Name
#   * Type Subtype
#   * Power/Toughness
#   * Cost
#   * Rarity
#   * Artist
#   * Set its from (In case page is from search)


require 'fileutils'

require 'rubygems'
require 'bundler/setup'

require 'mechanize'
require 'pry'
require 'progressbar'

require './daerb_drac'


module Scraper
  module Magiccardinfo
    class SetPage
      attr_accessor :agent, :directory, :page, :set_name, :card_rows, :cards


      def gather_cards
        ### open file #################

        self.page = agent.get("file:"+File.join(self.directory, set_name+".html"))


        ### row selector ##############

        self.card_rows = page.parser.css("table:nth-child(30) tr.even, table:nth-child(30) tr.odd")


        ### row card parser ##########

        self.card_rows.each do |card_row|
          extract_card_from card_row
        end


        puts "#{cards.count} Cards gathered"
      end


      def extract_card_from card_row
        card = Daerb::InfoCard.new

        values = card_row.css("td")

        card.parse_type_column values[2].text

        card.name   = values[1].text
        card.cost   = values[3].text
        card.rarity = values[4].text
        card.artist = values[5].text.strip
        card.set    = values[6].text
        card.set_number = values[0].text

        self.cards.push card
      end


      def initialize set_name
        self.agent = Mechanize.new

        base_dir = File.expand_path(File.dirname(__FILE__))
        self.directory = File.join(base_dir, "magiccardsinfo", "sets")

        self.set_name = set_name + "_en"
        self.cards    = Array.new
      end
    end
  end
end

Scraper::Magiccardinfo::SetPage.new("m14").gather_cards

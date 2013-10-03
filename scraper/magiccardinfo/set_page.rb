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
      attr_accessor :agent, :host, :directory, :page, :set_name, :card_rows, :cards


      def gather_cards
        ### open file #################

        self.page = agent.get("file:"+File.join(self.directory, set_name+".html"))


        ### row selector ##############

        self.card_rows = page.parser.css("table:nth-child(30) tr.even, table:nth-child(30) tr.odd")


        ### row card parser ##########

        self.card_rows.each do |card_row|
          extract_card_from card_row
        end
      end


      def extract_card_from card_row
        card = InfoCard.new

        
        card_row.css

      end


      def initialize set_name
        self.agent = Mechanize.new
        self.host = "http://magiccards.info"
        self.directory = File.join(Dir.pwd, "magiccardsinfo", "sets")

        self.set_name = set_name + "_en"
      end
    end
  end
end

Scraper::Magiccardinfo::SetPage.new("m14").gather_cards

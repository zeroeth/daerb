require 'rubygems'
require 'bundler/setup'

require 'pry'
require 'progressbar'

require './scraper/magiccardinfo/set_index'
require './scraper/magiccardinfo/set_page'

module Scraper
  module Magiccardinfo
    class GatherAllCards
      attr_accessor :cards

      def gather_and_report
        index = Scraper::Magiccardinfo::SetIndex.new
        index.get_set_names

        bar = ProgressBar.new "#{index.sets.count} Sets", index.sets.count

        index.sets.each do |set_name|
          page = Scraper::Magiccardinfo::SetPage.new(set_name.gsub('_en',''))
          page.gather_cards
          cards.push page.cards

          bar.inc
        end

        bar.finish

        cards.flatten!
      end

      def initialize
        self.cards = Array.new
      end
    end
  end
end

gatherer = Scraper::Magiccardinfo::GatherAllCards.new
gatherer.gather_and_report

binding.pry

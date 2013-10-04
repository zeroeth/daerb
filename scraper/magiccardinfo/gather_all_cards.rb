require 'rubygems'
require 'bundler/setup'

require 'pry'
require 'progressbar'

require './scraper/magiccardinfo/set_index'
require './scraper/magiccardinfo/set_page'

module Scraper
  module Magiccardinfo
    class GatherAllCards
      attr_accessor :cards, :set_pages

      def gather
        index = Scraper::Magiccardinfo::SetIndex.new
        index.get_set_names

        bar = ProgressBar.new "#{index.set_names.count} Sets", index.set_names.count

        index.set_names.each do |set_name|
          page = Scraper::Magiccardinfo::SetPage.new(set_name.gsub('_en',''))
          page.gather_cards

          self.set_pages.push page
          self.cards.push page.cards

          bar.inc
        end

        bar.finish

        cards.flatten!
      end


      def report
        sets = cards.group_by(&:set)
        max_length = sets.keys.collect(&:length).max

        puts ""

        sets.each_slice(4) do |row_of_pages|

          formatted_sets = Array.new

          row_of_pages.each do |set_name, set_cards|
            formatted_set = sprintf("[ %#{max_length}s %4d ]", set_name, set_cards.count)
            formatted_sets.push formatted_set
          end

          puts formatted_sets.join(" ")
        end

        puts ""
        puts "#{cards.count} Cards gathered"
      end


      def initialize
        self.cards     = Array.new
        self.set_pages = Array.new
      end
    end
  end
end

gatherer = Scraper::Magiccardinfo::GatherAllCards.new
gatherer.gather
gatherer.report

binding.pry

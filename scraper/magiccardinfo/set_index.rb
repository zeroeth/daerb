# Information available
# * List of all core sets
# * List of all blocks
#   * List of expansion sets in each block


require 'fileutils'

require 'rubygems'
require 'bundler/setup'

require 'mechanize'
require 'pry'


# TODO next have 3 levels of association for blocks, expansion sets, and cards

module Scraper
  module Magiccardinfo
    class SetIndex
      attr_accessor :agent, :directory, :blocks, :set_names


      def get_set_names
        page = agent.get "file:" + File.join(directory, "sitemap.html")

        set_name_matcher = "ul:nth-child(6) li:nth-child(2) li:nth-child(1) small , table:nth-child(32) td:nth-child(2) ul:nth-child(2) small, table:nth-child(32) td:nth-child(1) small"

        rows   = page.parser.css(set_name_matcher)
        values = rows.collect(&:text)
        self.set_names = values
      end


      def initialize
        self.agent = Mechanize.new

        base_dir = File.expand_path(File.dirname(__FILE__))
        self.directory = File.join(base_dir, "magiccardsinfo")

        self.blocks    = Array.new
        self.set_names = Array.new
      end

    end
  end
end

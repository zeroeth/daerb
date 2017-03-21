require 'fileutils'

require 'rubygems'
require 'bundler/setup'

require 'mechanize'
require 'pry'
require 'progressbar'


require './scraper/magiccardinfo/set_index'

module Scraper
  module Magiccardinfo
    class DownloadAllPages
      attr_accessor :agent, :host, :directory

      def get
        FileUtils.mkdir_p self.directory


        ### Download main page ###########
        page = agent.get URI.join(host, "sitemap.html")
        file_name = File.join(self.directory, page.filename)
        page.save_as file_name unless File.exists? file_name

        # use more iteration and siblings to the h1 vs nth child.
        links = page.parser.css SetIndex::SET_LINK_MATCHER % {element: "a"}

        # spoiler page format
        # query?q=%2B%2Be%3A#{set}%2Fen&v=spoiler
        #

        ### Download all card lists ######
        format = "%t: |%b %p%% => %i| %c/%C"
        bar = ProgressBar.create title:"#{links.count} Pages", total:links.count, format: format
        links.each do |link|
          page = agent.get link.attributes["href"]
          file_name = File.join(self.directory, "sets", page.uri.path[1..-1].gsub("/", "_"))
          FileUtils.mkdir_p File.dirname file_name
          page.save_as file_name unless File.exists? file_name

          bar.increment
        end
        bar.finish
      end

      def initialize
        self.agent = Mechanize.new
        self.host = "http://magiccards.info"

        base_dir = File.expand_path(File.dirname(__FILE__))
        self.directory = File.join(base_dir, "magiccardsinfo")
      end
    end
  end
end

Scraper::Magiccardinfo::DownloadAllPages.new.get

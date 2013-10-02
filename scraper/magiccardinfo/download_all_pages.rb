require 'fileutils'

require 'rubygems'
require 'bundler/setup'

require 'mechanize'
require 'pry'
require 'progressbar'



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
        set_link_matcher = "table:nth-child(32) td:nth-child(2) ul:nth-child(2) a , table:nth-child(32) td:nth-child(1) a"
        links = page.parser.css set_link_matcher

        ### Download all card lists ######
        bar = ProgressBar.new "#{links.count} Pages", links.count
        links.each do |link|
          page = agent.get link.attributes["href"]
          file_name = File.join(self.directory, "sets", page.uri.path[1..-1].gsub("/", "_"))
          FileUtils.mkdir_p File.dirname file_name
          page.save_as file_name unless File.exists? file_name
          bar.inc
        end
        bar.finish
      end

      def initialize
        self.agent = Mechanize.new
        self.host = "http://magiccards.info"
        self.directory = "magiccardsinfo"
      end
    end
  end
end

Scraper::Magiccardinfo::DownloadAllPages.new.get

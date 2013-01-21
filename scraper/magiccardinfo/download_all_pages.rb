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
        set_link_matcher = "table:nth-child(32) td:nth-child(2) ul:nth-child(2) ul li a, table:nth-child(32) td:nth-child(1) li li a"
        links = page.parser.css set_link_matcher


        ### Download all card lists ######
        set_pages = []
        links.each do |link|
          page = agent.get link.attributes["href"]
          set_pages << page
          file_name = File.join(self.directory, "sets", page.uri.path[1..-1].gsub("/", "_"))
          FileUtils.mkdir_p File.dirname file_name
          page.save_as file_name unless File.exists? file_name
        end


        image_links = []
        ### gather all image links ##########
        set_pages.each do |page|
          card_links = page.parser.css("table")[3].css("a")
          card_links.each do |link|
            # http://magiccards.info/rtr/en/1.html
            # http://magiccards.info/scans/en/rtr/1.jpg
            matcher = link.attributes["href"].text.match /\/(.+)\/(.+)\/(.+).html/
            image_links << URI.join(host, File.join("scans", matcher[2], matcher[1], "#{matcher[3]}.jpg"))
          end
        end


        bar = ProgressBar.new 'Images', image_links.count
        image_links.each do |link|
          file_name = File.join(self.directory, ".", link.path)
          FileUtils.mkdir_p File.dirname file_name
          agent.get(link).save(file_name) unless File.exists? file_name

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

require 'fileutils'

require 'rubygems'
require 'bundler/setup'

require 'mechanize'
require 'pry'
require 'progressbar'



module Scraper
  module Magiccardinfo
    class ImageDownloader 
      attr_accessor :agent, :host, :directory, :image_links, :pages

      def get

        ### collect all pages ###############

        set_page_files = Dir[ File.join(directory, "*.html") ]
        puts "#{set_page_files.count} Set pages found"

        set_page_files.each do |file_name|
          pages << agent.get("file:"+file_name)
        end


        ### gather all image links ##########

        pages.each do |page|
          gather_image_links_from page
        end

        puts "#{image_links.count} Image links collected"


        ### download all images ############

        download_all_images

      end


      def gather_image_links_from page
        card_links = page.parser.css("table")[3].css("a")
        card_links.each do |link|
          # Infer image link from page link:
          # http://magiccards.info/rtr/en/1.html
          # http://magiccards.info/scans/en/rtr/1.jpg

          matcher = link.attributes["href"].text.match /\/(.+)\/(.+)\/(.+).html/
          image_links << URI.join(host, File.join("scans", matcher[2], matcher[1], "#{matcher[3]}.jpg"))
        end
      end


      def download_all_images
        bar = ProgressBar.new "Downloading", image_links.count

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
        self.directory = File.join(Dir.pwd, "magiccardsinfo", "sets")
        # pwd or __FILE__

        self.image_links = Array.new
        self.pages       = Array.new
      end
    end
  end
end

Scraper::Magiccardinfo::ImageDownloader.new.get

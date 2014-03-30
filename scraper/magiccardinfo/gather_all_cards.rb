require 'rubygems'
require 'bundler/setup'

require 'pry'
require 'progressbar'
require 'colored'

require './scraper/magiccardinfo/set_index'
require './scraper/magiccardinfo/set_page'

module Scraper
  module Magiccardinfo
    class GatherAllCards
      attr_accessor :cards, :set_pages


      # Combine all the cards from each set page

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


      # Show various stats on cards.

      def report
        ### Cards in each set ##################################

        sets = cards.group_by(&:set)
        max_length = sets.keys.collect(&:length).max

        display_columns = (get_term_width / (max_length + 10)) # 10 comes from the formatting below

        puts ""
        puts "Cards by expansion set".cyan

        sets.each_slice(display_columns) do |row_of_pages|

          formatted_sets = Array.new

          row_of_pages.each do |set_name, set_cards|
            formatted_name   = sprintf("%#{max_length}s", set_name)
            formatted_number = sprintf("%4d", set_cards.count)
            formatted_set = "[ #{formatted_name.cyan} #{formatted_number.green} ] "
            formatted_sets.push formatted_set
          end

          puts formatted_sets.join
        end

        puts ""
        puts "#{cards.count} cards gathered. #{cards.group_by(&:name).keys.count} unique names."



        ### Cards in each type #################################

        sets = cards.group_by(&:primary_type)
        max_length = sets.keys.collect(&:length).max

        display_columns = (get_term_width / (max_length + 10)) # 10 comes from the formatting below

        puts ""
        puts "Cards by primary type".yellow

        sets.each_slice(display_columns) do |row_of_pages|

          formatted_sets = Array.new

          row_of_pages.each do |type_name, set_cards|
            formatted_name   = sprintf("%#{max_length}s", type_name)
            formatted_number = sprintf("%4d", set_cards.count)
            formatted_set = "[ #{formatted_name.yellow} #{formatted_number.blue} ] "
            formatted_sets.push formatted_set
          end

          puts formatted_sets.join
        end



        ### Cards by converted mana cost #######################

        sets = cards.group_by(&:converted_cost)
        max_length = sets.keys.collect{|key| key.to_s.length}.max

        display_columns = (get_term_width / (max_length + 10)) # 10 comes from the formatting below

        puts ""
        puts "Cards by converted mana cost".magenta

        sets.each_slice(display_columns) do |row_of_pages|

          formatted_sets = Array.new

          row_of_pages.each do |cost, set_cards|
            formatted_name   = sprintf("%#{max_length}s", cost)
            formatted_number = sprintf("%4d", set_cards.count)
            formatted_set = "[ #{formatted_name.magenta} #{formatted_number.red} ] "
            formatted_sets.push formatted_set
          end

          puts formatted_sets.join
        end



        ### Cards by artist ####################################

        cards_by_artist = cards.group_by(&:artist)
        
        data_set = cards_by_artist.map{|artist, cards| [artist, cards.count]}
        data_set = data_set.sort_by(&:last).reverse
        data_set = data_set[0..100] # OR by median size

        display_table_for data_set, :title => "Cards by artist", :key => :blue, :value => :white



        ### Artist contribution ################################

        cards_by_artist  = cards.group_by(&:artist)
        artists_by_cards = cards_by_artist.group_by{|artist, cards| cards.count }

        data_set = artists_by_cards.map{|card_count, artists| [artists.count, card_count] }
        data_set = data_set.sort_by(&:last).reverse

        display_table_for data_set, :title => "Artist contributions (Artists/Cards)", :key => :red, :value => :white


        ### Types in each set

        ### Sub types in each set

        ### Number of sets each card appears in

      end



      ### Colored table output function ########################

      def display_table_for data_set, options = {}
        options = {:title => "Data set", :key => :cyan, :value => :yellow}.merge options
        
        max_key_length   = data_set.collect{|data_row| data_row.first.to_s.length + 1 }.max
        max_value_length = data_set.collect{|data_row| data_row.last.to_s.length  + 1 }.max

        display_columns  = (get_term_width / (max_key_length + max_value_length + 6))

        puts ""
        puts Colored.colorize(options[:title], :foreground => options[:key])

        data_set.each_slice(display_columns) do |row_of_data|

          formatted_sets = Array.new

          row_of_data.each do |key, value|
            formatted_name   = sprintf( "%#{max_key_length}s",   key   )
            formatted_number = sprintf( "%#{max_value_length}d", value )

            colored_name   = Colored.colorize(formatted_name,   :foreground => options[:key]   )
            colored_number = Colored.colorize(formatted_number, :foreground => options[:value] )

            formatted_sets.push "[ #{colored_name} #{colored_number} ] "
          end

          puts formatted_sets.join
        end
      end



      # Term width, borrowed from progressbar

      DEFAULT_WIDTH = 80
      def get_term_width
        term_width = if ENV['COLUMNS'] =~ /^\d+$/
          ENV['COLUMNS'].to_i
        elsif (RUBY_PLATFORM =~ /java/ || (!STDIN.tty? && ENV['TERM'])) && shell_command_exists?('tput')
          `tput cols`.to_i
        elsif STDIN.tty? && shell_command_exists?('stty')
          `stty size`.scan(/\d+/).map { |s| s.to_i }[1]
        else
          DEFAULT_WIDTH
        end

        if term_width > 0
          term_width
        else
          DEFAULT_WIDTH
        end
      rescue Exception => e
        binding.pry
        DEFAULT_WIDTH
      end

      def shell_command_exists?(command)
        ENV['PATH'].split(File::PATH_SEPARATOR).any?{|d| File.exists? File.join(d, command) }
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

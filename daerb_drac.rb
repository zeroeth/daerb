# encoding: UTF-8 is over 9000

require 'bundler/setup'
require 'pry'

module Daerb
  class GathererCard
    attr_accessor :name, :cost, :type, :power_and_toughness, :rules, :sets_and_rarity, :color, :loyalty

    attr_accessor :main_type, :sub_types
    attr_accessor :sets
    attr_accessor :power, :toughness
    attr_accessor :colors

    attr_accessor :set_number, :set, :rarity, :id, :artist

    def rules=(value)
      @rules = value.split(/\n/)
    end

    def type=(value)
      @type = value
      types = value.split(/[ ]{1,2}. /)
      self.main_type = types[0]
      self.sub_types = types[1].split if types[1]
    end

    def sets_and_rarity=(value)
      @sets_and_rarity = value
      self.sets = value.split(', ').collect{|set| set.split(/ (Mythic Rare|\S*)$/)}
    end

    def power_and_toughness=(value)
      @power_and_toughness = value
      format = /([+-]?\d{1,2}|\d*[-+]*\*)/
      numbers = value.match(/^\(#{format}\/#{format}\)$/)

      if numbers
        self.power     = numbers[1]
        self.toughness = numbers[2]
      end
    end

    def color=(value)
      @color = value
      self.colors = value.split("/")
    end
  end


  # TODO refactor 'card' and have parsers for each moved into their folder

  class InfoCard
    attr_accessor :set_number, :name, :primary_type, :types, :loyalty, :power, :toughness, :cost, :rarity, :artist

    attr_accessor :set, :color, :converted_cost


    def parse_type_column(string)
      # Extract power and toughness

      single_match = /([+-]?\d{1,2}|\d*[-+]*\*)/
      dual_match   = /\s#{single_match}\/#{single_match}/
      numbers      = string.match dual_match
      string.gsub! dual_match, ''

      if numbers
        self.power     = numbers[1]
        self.toughness = numbers[2]
      end


      # Extract loyalty

      loyalty_match = /\s\(Loyalty: (\d{1,})\)/
      number = string.match loyalty_match
      string.gsub! loyalty_match, ''
      if number
        self.loyalty = number[1]
      end


      # Extract types

      self.types = string.split " — "
      self.primary_type = types.first
    end


    # Handle old summon type

    def primary_type= string
      if string.match /Summon/
        values = string.split
        @primary_type = values[0]
        self.types = values
      else
        @primary_type = string
      end
    end


    def cost=(string)
      return if string.empty?

      @cost = string.clone

      # calculate converted cost

      self.converted_cost = 0


      # remove X cost since it is 0 if not in play

      string.gsub!('X', '')


      # extract digit value

      number = string.match /\d+/
      string.gsub! /\d+/, ''
      if number
        self.converted_cost += number[0].to_i
      end


      # replace complex rules with a single token, we can extract everything in a later version

      string.gsub! /(\{.*?\})/, 'H'
      self.converted_cost += string.split('').count
    end

  end
end

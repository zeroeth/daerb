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
    end

  end
end

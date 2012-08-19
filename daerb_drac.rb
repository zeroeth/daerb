module Daerb
  class Card
    attr_accessor :name, :cost, :type, :power_and_toughness, :rules, :sets_and_rarity, :color, :loyalty
    attr_accessor :main_type, :sub_types
    attr_accessor :sets

    def rules=(value)
      @rules = value.split(/\n/)
    end

    def type=(value)
      @type = value
      types = value.split(/ . /)
      self.main_type = types[0]
      self.sub_types = types[1].split if types[1]
    end

    def sets_and_rarity=(value)
      @sets_and_rarity = value
      self.sets = value.split(', ').collect{|set| set.split(/ (\S*)$/)}
    end
  end
end

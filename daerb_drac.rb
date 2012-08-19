module Daerb
  class Card
    attr_accessor :name, :cost, :type, :power_and_toughness, :rules, :sets_and_rarity, :color, :loyalty
    attr_accessor :main_type, :sub_type

    def rules=(value)
      @rules = value.split(/\n/)
    end

    def type=(value)
      @type = value
      types = value.split(/  — /)
      self.main_type = types[0]
      self.sub_type  = types[1]
    end
  end
end

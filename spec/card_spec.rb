# It was the night before Christmas and all through the house, not a creature was coding: UTF-8, not even with a mouse.

require 'spec_helper'

require 'simplecov'
SimpleCov.start

require './daerb_drac'

describe Daerb::GathererCard do
  let(:card) { Daerb::GathererCard.new }
  context 'parsing' do
    describe '#type' do
      it 'separates main type and sub types' do
        card.type = "Creature - Zombie Cat"
        card.main_type.should == 'Creature'
        card.sub_types.should == ['Zombie', 'Cat']
      end

      it 'separates types with two spaces' do
        card.type = "Creature  - Zombie Cat"
        card.main_type.should == 'Creature'
        card.sub_types.should == ['Zombie', 'Cat']
      end
    end

    describe '#sets_and_rarity' do
      it 'gathers sets and their rarity' do
        card.sets_and_rarity = "Woo Woo Rare, Waa Common, Super Set Mythic Rare"
        card.sets.should == [["Woo Woo", "Rare"], ["Waa", "Common"], ["Super Set", "Mythic Rare"]]
      end
    end

    describe '#power_and_toughness' do
      it 'separates into two' do
        card.power_and_toughness = "(4/5)"
        card.power.should     == "4"
        card.toughness.should == "5"
      end

      it 'sets negative toughness' do
        card.power_and_toughness = "(-1/5)"
        card.power.should     == "-1"
        card.toughness.should == "5"
      end

      it 'sets double digits' do
        card.power_and_toughness = "(11/10)"
        card.power.should     == "11"
        card.toughness.should == "10"
      end

      it 'handles stars' do
        card.power_and_toughness = "(*/*)"
        card.power.should     == "*"
        card.toughness.should == "*"
      end

      it 'handles stars with toughness modifier' do
        card.power_and_toughness = "(*/1+*)"
        card.power.should     == "*"
        card.toughness.should == "1+*"
      end

      it 'handles stars with negative toughness modifier' do
        card.power_and_toughness = "(*/7-*)"
        card.power.should     == "*"
        card.toughness.should == "7-*"
      end

      it 'handles stars with power modifier' do
        card.power_and_toughness = "(1+*/2)"
        card.power.should     == "1+*"
        card.toughness.should == "2"
      end

      it 'handles unhinged cards' do
        #"(1/3{1/2})",
        #"({1/2}/{1/2})",
        #"(*{^2}/*{^2})",
        #"(2{1/2}/2{1/2})",
        #"(3{1/2}/3{1/2})"

        # ignore for now
        card.power_and_toughness = "(3{1/2}/3{1/2})"
        card.power.should     == nil
        card.toughness.should == nil
      end
    end

    describe '#color' do
      it 'separates colors' do
        card.color = "Black/White"
        card.colors.should == ["Black", "White"]
      end
    end

    describe '#cost' do
      it 'separates costs'
      # into like colorless/w/b/b/g/r/x... how to handle phrexian? and
      # either/ors
    end

    describe '#rules' do
      it 'separates rules' do
        card.rules = "He attacks\nYou Die"
        card.rules.should == ["He attacks", "You Die"]
      end
    end
  end
end


describe Daerb::InfoCard do
  let(:card) { Daerb::InfoCard.new }
  context 'parsing' do
    describe '#type_column' do
      it 'handles instants' do
        card.parse_type_column "Instant"

        card.primary_type.should == "Instant"
        card.types.should == ["Instant"]
      end


      it 'handles sorcery' do
        card.parse_type_column "Sorcery"

        card.primary_type.should == "Sorcery"
        card.types.should == ["Sorcery"]
      end


      it 'handles enchantments' do
        card.parse_type_column "Enchantment — Aura"

        card.primary_type.should == "Enchantment"
        card.types.should == ["Enchantment", "Aura"]


        card.parse_type_column "Enchantment"

        card.primary_type.should == "Enchantment"
        card.types.should == ["Enchantment"]
      end


      it 'handles planeswalkers' do
        card.parse_type_column "Planeswalker — Ral (Loyalty: 4)"

        card.primary_type.should == "Planeswalker"
        card.types.should == ["Planeswalker", "Ral"]
        card.loyalty == "4"
      end


      it 'handles creatures' do
        card.parse_type_column "Creature — Angel 2/4"

        card.primary_type.should == "Creature"
        card.types.should == ["Creature", "Angel"]

        card.power.should     == "2"
        card.toughness.should == "4"
      end


      it 'handles legendary creatures' do
        card.parse_type_column "Legendary Creature — Human Soldier 2/5"

        card.primary_type.should == "Legendary Creature"

        # NOTE a lot of ways to go here. like "Legendary Creature" and "Human Soldier", or all 4 words
        card.types.should == ["Legendary Creature", "Human Soldier"] # ["Legendary", "Creature", "Human", "Soldier"]

        card.power.should     == "2"
        card.toughness.should == "5"
      end


      it 'handles basic lands' do
        card.parse_type_column "Land"

        card.primary_type.should == "Land"
        card.types.should == ["Land"]
      end


      it 'handles special lands' do
        card.parse_type_column "Land — Gate"

        card.primary_type.should == "Land"
        card.types.should == ["Land", "Gate"]
      end


      it 'handles star power and toughness' do
        card.parse_type_column "Creature — Nightmare Horse */*"

        card.primary_type.should == "Creature"
        card.types.should == ["Creature", "Nightmare Horse"]
        card.power.should     == "*"
        card.toughness.should == "*"
      end

      it 'handles negative power and toughness'
      it 'handles combination power and toughness' # the strange ones
    end
  end
end

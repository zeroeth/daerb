require 'spec_helper'
require './daerb_drac'

describe Daerb::Card do
  let(:card) { Daerb::Card.new }
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
  end
end

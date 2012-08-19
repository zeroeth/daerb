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
        card.power.should == "4"
        card.toughness.should == "5"
      end

      it 'handles stars'
      it 'handles halves'
    end

    describe '#color' do
      it 'separates colors'
    end

    describe '#cost' do
      it 'separates costs'
      # into like colorless/w/b/b/g/r/x... how to handle phrexian? and
      # either/ors
    end
  end
end

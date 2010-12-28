#$LOAD_PATH.unshift File.join(File.dirname(__FILE__), "..", "..", "..", "lib")
require 'test_helper'
#require 'test/unit'
require 'dice_cup/dice_cup'

class DiceTest < ActiveSupport::TestCase
  include DiceCup

  def setup
    @seed = rand(10**100)
  end

  def test_dice_cup
    srand @seed
    _d20a = rand(20)+1
    _d20b = rand(20)+1
    _2d6 = (rand(6)+1)+(rand(6)+1)
#    _2d6a7 = (rand(6)+1)+(rand(6)+1)+7
    _3d6 = (rand(6)+1)+(rand(6)+1)+(rand(6)+1)
    _4dF = (rand(3)-1)+(rand(3)-1)+(rand(3)-1)+(rand(3)-1)
    srand @seed
    dice = Cup.new('d20')
    assert_equal _d20a, dice.value
    assert_equal _d20b, dice.roll
    assert_equal _d20b, dice.value
    dice.dice = '2d6'
    assert_equal _2d6, dice.roll
    assert_equal _2d6, dice.value
#    assert_equal _2d6a7, dice.roll('+7')
#    assert_equal _2d6a7, dice.value
    assert_equal _3d6, dice.roll('3d6')
    assert_equal _3d6, dice.value
    dice.dice = '4dF'
    assert_equal _4dF, dice.roll
    assert_equal _4dF, dice.value
    assert_equal 'ERROR: Unexpected Characters: 5-g', dice.roll('5-g')
  end
end


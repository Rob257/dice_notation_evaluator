#$LOAD_PATH.unshift File.join(File.dirname(__FILE__), "..", "..", "..", "lib")
require 'test_helper'
#require 'test/unit'
#require 'rubygems'
#require 'polyglot'
require 'treetop'
require 'dice_cup/dice_notation_modules'
require 'dice_cup/dice_notation'

class DiceNotationParserTest < ActiveSupport::TestCase
  include DicePrep

  def roll_dice(input)
    output = dice_prep input
    result = @parser.parse(output)
    unless result
      puts @parser.terminal_failures.join("\n")
    end
    assert !result.nil?
    result.evaluate
  end

  def setup
    @parser = DiceNotationParser.new
    @seed = rand(10**100)
  end

  def test_number
    assert_equal 0, roll_dice('0')
    assert_equal 1, roll_dice('1')
    assert_equal 123, roll_dice('123')
    assert_equal -123, roll_dice('-123')
    assert_equal 3.5, roll_dice('3.5')
    assert_equal -3.5, roll_dice('-3.5')
  end

  def test_addition
    assert_equal 10, roll_dice('5 + 5')
  end

  def test_subtraction
    assert_equal 0, roll_dice('5 - 5')
  end

  def test_multiplication
    assert_equal 6, roll_dice('3 * 2')
  end

  def test_division
    assert_equal 3, roll_dice('6 / 2')
  end

  def test_order_of_operations
    assert_equal 11, roll_dice('1 + 2 * 3 + 4')
    assert_equal 4, roll_dice('4/2*2')
    assert_equal 4, roll_dice('4-2+2')
  end

  def test_parentheses
    assert_equal 25, roll_dice('(5 + 0) * (10 - 5)')
    assert_equal 26, roll_dice('3*(4+4)+(7-5)')
    assert_equal 30, roll_dice('3*((4+4)+(7-5))')
  end

  def test_dice_rolls
    srand @seed
    _2d6 = (rand(6)+1)+(rand(6)+1)
    _2z6 = rand(6)+rand(6)
    _2z6a2z6 = (rand(6)+rand(6))+(rand(6)+rand(6))
    _p2z6a2pmp2z6a2p = ((rand(6)+rand(6))+2)*((rand(6)+rand(6))+2)
    v = 0; (rand(2)+rand(2)).times do v+= rand(2) end; _p2z2pz2 = v
    v = 0; (rand(2)+2).times do v+= rand(2) end; _2appz2a2pz2p = v + 2
    _d20 = rand(20)+1
    srand @seed
    assert_equal _2d6, roll_dice('2d6')
    assert_equal _2z6, roll_dice('2z6')
    assert_equal _2z6a2z6, roll_dice('2z6+2z6')
    assert_equal _p2z6a2pmp2z6a2p, roll_dice('(2z6+2)*(2z6+2)')
    assert_equal _p2z2pz2, roll_dice('(2z2)z2')
    assert_equal _2appz2a2pz2p, roll_dice('2+((z2+2)z2)')
    assert_equal _d20, roll_dice('d20')
  end

  def test_dice_nest_rolls
    srand @seed
    _4cpz3s1p = (rand(3)-1)+(rand(3)-1)+(rand(3)-1)+(rand(3)-1)
    _4dppz6s1pd4p = ((rand(6)-1)/4)+((rand(6)-1)/4)+((rand(6)-1)/4)+((rand(6)-1)/4)
    v = 0; (rand(2)+rand(2)).times do v+= (rand(2)+rand(2)) end; _p2z2pzp2z2p = v
    srand @seed
    assert_equal _4cpz3s1p, roll_dice('4c(z3-1)')
    assert_equal _4dppz6s1pd4p, roll_dice('4c((1z6-1)/4)rd')
    assert_equal _p2z2pzp2z2p, roll_dice('(2z2)c(2z2)')
    assert (4..8) === roll_dice('2c(2d2)')
  end

  def test_named_dice
    srand @seed
    _percentile = rand(100)+1
    _4df = (rand(3)-1)+(rand(3)-1)+(rand(3)-1)+(rand(3)-1)
    _4df3 = (rand(3)-1)+(rand(3)-1)+(rand(3)-1)+(rand(3)-1)
    val = 0
    4.times do val += ((rand(4)-1)/2).floor end
    _4df4 = val
    val = 0
    4.times do val += ((rand(5)-1)/3).floor end
    _4df5 = val
    val = 0
    4.times do val += ((rand(6)-1)/4).floor end
    _4df6 = val
    srand @seed
    assert_equal _percentile, roll_dice('d%')
    assert_equal _4df, roll_dice('4dF')
    assert_equal _4df3, roll_dice('4dF3')
    assert_equal _4df4, roll_dice('4dF4')
    assert_equal _4df5, roll_dice('4dF5')
    assert_equal _4df6, roll_dice('4dF6')
  end

  def test_dice_keep_rolls
    assert (1..6) === roll_dice('2d6kh')
    assert (1..6) === roll_dice('2d6kl')
    assert (2..12) === roll_dice('3d6kh2')
    assert (2..12) === roll_dice('3d6kl2')
  end

  def test_complex_division_and_subtraction
    srand @seed
    _z100Dz20a = rand(100)
    _z100Dz20b = rand(20)
    _z100Dz20 = _z100Dz20a.to_f / _z100Dz20b
    _z100Sz20a = rand(100)
    _z100Sz20b = rand(20)
    _z100Sz20 = _z100Sz20a.to_f - _z100Sz20b
    srand @seed
    assert_in_delta( _z100Dz20, roll_dice('z100 / z20'), 0.005 )
    assert_in_delta( _z100Sz20, roll_dice('z100 - z20'), 0.005 )
  end
end


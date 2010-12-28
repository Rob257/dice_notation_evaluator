# FIXME incorrect division by zero in dice_notation.treetop line 60
#require 'rubygems'
#require 'polyglot'
require 'treetop'
require 'dice_cup/dice_notation_modules'
require 'dice_cup/dice_notation'

#  DOCUMENTATION for Dice class
#  _
#  d = Dice.new
#  sets the attr_accessor :dice to d6 and rolls
#  _
#  d = Dice.new('d20')
#  sets attr_accessor :dice to d20 and rolls
#  _
#  d.value
#  returns the value of the last roll
#  _
#  d.dice = 'd257'
#  sets attr_accessor :dice to d257
#  _
#  d.dice
#  returns value of attr_accessor :dice
#  _
#  d.roll
#  sets attr_reader :value to a roll of attr_accessor :dice
#  _
#  d.roll('+8')
#  sets attr_reader :value to a roll of attr_accessor :dice +8
#  _
#  d.roll('d42')
#  sets attr_reader :value to a roll of d42
#  _

module DiceCup

  class Cup
    include DicePrep

    attr_reader :value, :expanded
    attr_accessor :dice

    def initialize dice='d6'
      @parser = DiceNotationParser.new
      @dice = dice
      roll
    end

    def roll dice=@dice
  # TODO   if dice =~ /^[\*\/\+\-]/ then dice = @dice + dice end
      @value = parse_and_evaluate(dice)
    end#def roll

    def parse_and_evaluate(input)
      @expanded = dice_prep input
      result = @parser.parse @expanded
      unless result
        "ERROR: Unexpected Characters: #{input}"
      else
        output = result.evaluate
        if output == output.to_i
          output.to_i
        else
          output
        end
      end
    end#def parse_and_evaluate

  end#class Cup

end#module DiceCup


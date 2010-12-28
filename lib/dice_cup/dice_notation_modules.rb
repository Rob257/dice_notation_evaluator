module DicePrep
  def dice_prep input
    expression = input.dup
#~ print 'dice prep in: ' + expression + "\n"
    expression.upcase!
    expression.gsub!(' ','') # gets rid of spaces

    expression.gsub!(/D%/){ 'D100' } # converts d%
    expression.gsub!(/Z%/){ 'Z100' } # converts z%

    expression.gsub!(/DF(\d+)/){ 'C((1z' + $1 +'-1)/' + ($1.to_i - 2).to_s + ')rd' } # converts dF#'s

    expression.gsub!(/DF/){ 'C(1z3-1)' } # converts dF's

    expression.gsub!(/RU/){ 'ru' }
    expression.gsub!(/RD/){ 'rd' }

    expression.gsub!(/(KH|KL)([^\d\(]|$)/){ $1 + '1' + $2 } # puts a 1 after kh's

    expression.gsub!(/KH/){ 'kh' }
    expression.gsub!(/KL/){ 'kl' }

    expression.gsub!(/(^|[^\d\)])(D|Z|C)/){ $1 + '1' + $2 } # puts a 1 in front of d's

    expression.gsub!(/D/){ 'd' }
    expression.gsub!(/Z/){ 'z' }
    expression.gsub!(/C/){ 'c' }

    expression.gsub!(/\/([^\*\/\+\-kr]+)/){ '*(1/' + $1 + ')' } # converts /# to *(1/#) associative property of multiplication

    expression.gsub!(/\-([^\*\/\+\-kr]+)/){ '+(0-' + $1 + ')' } # converts -# to +(0-#) associative property of addition

    expression.gsub!(/(^|\()(\+)/){ $1 + '' } # removes the + put in by the previous

    expression.gsub!(/(^|\()\-/){ $1 + '0-' } # converts - at the front of the line

#~ print 'dice prep out: ' + expression + "\n"
    expression
  end
end

module DiceNotation
  class DiceOperation < Treetop::Runtime::SyntaxNode
    def evaluate(env={})
#~ print( 'dice evaluate in: quantity: ',quantity.text_value,', dice_op: ',dice_op.text_value,', faces: ',faces.text_value,', keep: ',keep.text_value,".\n" )
      rolls = []
      quantity.evaluate(env).to_i.times do |q|
        case dice_op.text_value
        when 'd'
          rolls[q] = rand(faces.evaluate(env))+1
        when 'z'
          rolls[q] = rand(faces.evaluate(env))
        else
          rolls[q] = faces.evaluate(env)
#~ print rolls[q], "\n"
        end
      end

      if keep.text_value =~ /(kh|kl)(\d+)/
        kept = $2.to_i
        rolls.sort!
        if $1 == 'kh'
          rolls = rolls[(-kept),kept]
        else
          rolls = rolls[0,kept]
        end
      end

      value = 0
      if round.text_value =~ /(ru|rd)/
        if $1 == 'ru'
          rolls.each do |roll| value += roll.ceil end
        else
          rolls.each do |roll| value += roll.floor end
        end
      else
        rolls.each do |roll| value += roll end
      end

#~ print( "dice evaluate out: ",value,"\n" )
      value
    end
  end
end


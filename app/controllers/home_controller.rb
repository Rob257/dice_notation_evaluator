require 'dice_cup/dice_cup'

class HomeController < ApplicationController
  include DiceCup

  skip_before_filter :authorize_admin
  skip_before_filter :authorize_user

  def index
    dc = Cup.new( params[:dice] || 'd42' )
    @dn = UserNotation.new( :notation => dc.dice, :result => dc.value )
    @user = UserAccount.find_by_id(session[:user_id])
    unless @user.nil?
      @user.user_notations.each do |un|
        un.result = dc.roll un.notation
      end
    end
  end

  def evaluate
    dc = Cup.new( params[:dice] )
    @dn = UserNotation.new( :notation => dc.dice, :result => dc.value )
    @dn_old = params[:dice_old]
    index_unless_xhr
  end

  def show_help
    session[:help] = 'show'
    index_unless_xhr
  end

  def hide_help
    session[:help] = 'hide'
    index_unless_xhr
  end

private

  def index_unless_xhr
    unless request.xhr?
      redirect_to :action => :index
    end
  end

end


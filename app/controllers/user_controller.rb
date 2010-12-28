class UserController < ApplicationController
  skip_before_filter :authorize_admin
  skip_before_filter :authorize_user, :only => [ :login, :new, :create ]

  # GET /user/login
  # POST /user/login
  def login
    if request.post?
      user = UserAccount.authenticate(params[:name], params[:password])
      if user
        session[:user_id] = user.id
        uri = session[:original_uri]
        session[:original_uri] = nil
        redirect_to(uri || { :controller => 'home', :action => "index" })
      else
        flash.now[:notice] = "Invalid user/password combination"
      end
    end
  end

  # GET /user/logout
  def logout
    session[:user_id] = nil
    flash[:notice] = "Logged out"
    redirect_to(:controller => 'home', :action => "index" )
  end

  def save_notation
    @user = UserAccount.find_by_id(session[:user_id])
    dn = UserNotation.new( :notation => params[:dice] )
    @user.user_notations << dn
    if @user.save
      flash[:notice] = 'Notation saved.'
      redirect_to :controller => 'home', :action => :index
    else
      redirect_to :controller => 'home', :action => :index
    end

  end

  def delete_notation
    @user = UserAccount.find_by_id(session[:user_id])
    udn = @user.user_notations.find_by_id(params[:id])
    udn.destroy
    redirect_to :controller => 'home', :action => :index
  end

  # GET /user
  def index
    @user = UserAccount.find_by_id(session[:user_id])
  end

  # GET /user/edit
  def edit
    @user = UserAccount.find_by_id(session[:user_id])
  end

  # POST /user/edit
  def update
    @user = UserAccount.find_by_id(session[:user_id])

    if @user.update_attributes(params[:user])
      flash[:notice] = 'User was successfully updated.'
      redirect_to :action => 'index'
    else
      render :action => "edit"
    end
  end

  # GET /user/new
  def new
    @user = UserAccount.find_by_id(session[:user_id])
    unless @user
      @user = UserAccount.new
    else
      flash[:notice] = "You are currently logged in as #{@user.name}."
      redirect_to :action => 'index'
    end
  end

  # POST /user/new
  def create
    @user = UserAccount.new(params[:user])

    if @user.save
      session[:user_id] = @user.id
      flash[:notice] = 'User account was successfully created.'
      redirect_to :controller => 'home', :action => 'index'
    else
      render :action => "new"
    end
  end

  # DELETE /user/delete
  def destroy
    @user = UserAccount.find_by_id(session[:user_id])
    session[:user_id] = nil
    @user.destroy
    flash[:notice] = "User account deleted"
    redirect_to(:controller => 'home', :action => "index" )
  end

end


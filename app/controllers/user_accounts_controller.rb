class UserAccountsController < ApplicationController
  layout 'admin'
  skip_before_filter :authorize_user

  # GET /user_accounts
  # GET /user_accounts.xml
  def index
    @admin = AdminAccount.find_by_id(session[:admin_id])
    @user_accounts = UserAccount.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @user_accounts }
    end
  end

  # GET /user_accounts/1
  # GET /user_accounts/1.xml
  def show
    @admin = AdminAccount.find_by_id(session[:admin_id])
    @user_account = UserAccount.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @user_account }
    end
  end

  # GET /user_accounts/new
  # GET /user_accounts/new.xml
  def new
    @admin = AdminAccount.find_by_id(session[:admin_id])
    @user_account = UserAccount.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @user_account }
    end
  end

  # GET /user_accounts/1/edit
  def edit
    @admin = AdminAccount.find_by_id(session[:admin_id])
    @user_account = UserAccount.find(params[:id])
  end

  # POST /user_accounts
  # POST /user_accounts.xml
  def create
    @user_account = UserAccount.new(params[:user_account])

    respond_to do |format|
      if @user_account.save
        format.html { redirect_to(@user_account, :notice => 'User account was successfully created.') }
        format.xml  { render :xml => @user_account, :status => :created, :location => @user_account }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @user_account.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /user_accounts/1
  # PUT /user_accounts/1.xml
  def update
    @user_account = UserAccount.find(params[:id])

    respond_to do |format|
      if @user_account.update_attributes(params[:user_account])
        format.html { redirect_to(@user_account, :notice => 'User account was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @user_account.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /user_accounts/1
  # DELETE /user_accounts/1.xml
  def destroy
    @user_account = UserAccount.find(params[:id])
    @user_account.destroy

    respond_to do |format|
      format.html { redirect_to(user_accounts_url) }
      format.xml  { head :ok }
    end
  end

end


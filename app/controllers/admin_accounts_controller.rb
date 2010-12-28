class AdminAccountsController < ApplicationController
  layout 'admin'
  skip_before_filter :authorize_user

  # GET /admin_accounts
  # GET /admin_accounts.xml
  def index
    @admin = AdminAccount.find_by_id(session[:admin_id])
    @admin_accounts = AdminAccount.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @admin_accounts }
    end
  end

  # GET /admin_accounts/1
  # GET /admin_accounts/1.xml
  def show
    @admin = AdminAccount.find_by_id(session[:admin_id])
    @admin_account = AdminAccount.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @admin_account }
    end
  end

  # GET /admin_accounts/new
  # GET /admin_accounts/new.xml
  def new
    @admin = AdminAccount.find_by_id(session[:admin_id])
    @admin_account = AdminAccount.new

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @admin_account }
    end
  end

  # GET /admin_accounts/1/edit
  def edit
    @admin = AdminAccount.find_by_id(session[:admin_id])
    @admin_account = AdminAccount.find(params[:id])
  end

  # POST /admin_accounts
  # POST /admin_accounts.xml
  def create
    @admin_account = AdminAccount.new(params[:admin_account])

    respond_to do |format|
      if @admin_account.save
        format.html { redirect_to(@admin_account, :notice => 'Admin account was successfully created.') }
        format.xml  { render :xml => @admin_account, :status => :created, :location => @admin_account }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @admin_account.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /admin_accounts/1
  # PUT /admin_accounts/1.xml
  def update
    @admin_account = AdminAccount.find(params[:id])

    respond_to do |format|
      if @admin_account.update_attributes(params[:admin_account])
        format.html { redirect_to(@admin_account, :notice => 'Admin account was successfully updated.') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @admin_account.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /admin_accounts/1
  # DELETE /admin_accounts/1.xml
  def destroy
    @admin_account = AdminAccount.find(params[:id])
    begin
      flash[:notice] = "Admin #{@admin_account.name} deleted"
      @admin_account.destroy
    rescue Exception => e
      flash[:notice] = e.message
    end

    respond_to do |format|
      format.html { redirect_to(admin_accounts_url) }
      format.xml  { head :ok }
    end
  end



end


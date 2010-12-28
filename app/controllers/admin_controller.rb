class AdminController < ApplicationController
  skip_before_filter :authorize_user
  skip_before_filter :authorize_admin, :only => [ :login ]

  def index
    @admin = AdminAccount.find_by_id(session[:admin_id])
  end

  def login
    if request.post?
      admin = AdminAccount.authenticate(params[:name], params[:password])
      if admin
        session[:admin_id] = admin.id
        uri = session[:original_uri]
        session[:original_uri] = nil
        redirect_to(uri || { :action => "index" })
      else
        flash.now[:notice] = "Invalid user/password combination"
      end
    end
  end

  def logout
    session[:admin_id] = nil
    flash[:notice] = "Logged out"
    redirect_to(:controller => 'home', :action => "index" )
  end

end


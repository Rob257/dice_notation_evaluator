class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :authorize_admin
  before_filter :authorize_user


protected

  def authorize_admin
    unless AdminAccount.find_by_id(session[:admin_id])
      session[:original_uri] = request.fullpath
      flash[:notice] = "Please log in"
      redirect_to :controller => 'admin' , :action => 'login'
    end
  end

  def authorize_user
    unless UserAccount.find_by_id(session[:user_id])
      session[:original_uri] = request.fullpath
      flash[:notice] = "Please log in"
      redirect_to :controller => 'user' , :action => 'login'
    end
  end


end


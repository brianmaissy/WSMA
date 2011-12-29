class ApplicationController < ActionController::Base
  protect_from_forgery

  before_filter :fetch_logged_user

  protected

  def fetch_logged_user
    begin
      @logged_user = User.find(session[:user_id]) unless session[:user_id].blank?
    rescue ActiveRecord::RecordNotFound
      session[:user_id] = nil
      @logged_user = nil
      flash[:notice] = "Logged out"
    end
  end

  def authenticate
    unless @logged_user
      session[:original_uri] = request.url
      flash[:notice] = "Please log in to access this page"
      redirect_to_login
    end
  end

  def authorize_user
    unless @logged_user.access_level >= 2 or (@logged_user.access_level == 1 and params[:id].to_i == @logged_user.id)
      flash[:notice] = "You do not have the privileges to see another user's page"
        redirect_to :controller => request[:controller], :action => request[:action], :id => @logged_user.id
    end
  end

  def authorize_wsm
    unless @logged_user.access_level >= 2
      session[:original_uri] = request.url
      flash[:notice] = "Please log in to access workshift manager area"
      redirect_to_login
    end
  end

  def authorize_admin
    unless @logged_user.access_level == 3
      session[:original_uri] = request.url
      flash[:notice] = "Please log in to access administrative area"
      redirect_to_login
    end
  end

  def redirect_to_login
    redirect_to :controller => :users, :action => :login
  end

  def format_errors(errors)
    (errors.full_messages.join "<br>").html_safe
  end

end

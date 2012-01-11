class AdminController < ApplicationController

  before_filter :authenticate
  before_filter :authorize_admin
  
  def index
    respond_to do |format|
      format.html # index.html.erb
    end
  end

  def set_admin_active_house
    session[:admin_active_house] = params[:house]
    redirect_to :back
  end

end

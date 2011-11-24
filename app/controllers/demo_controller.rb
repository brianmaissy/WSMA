class DemoController < ApplicationController

  def advance_time
    #TimeProvider.advance_mock_time(params[:hours].hours)
    flash[:notice] = "Time advanced by #{params[:hours]} hours"
    respond_to do |format|
      format.js
    end
  end
  
  # GET /users
  # GET /users.json
  def index
   
  end
	
  def login
  
  end
  
  def show
    @page = params[:id]

    render @page

  end
  
end
 

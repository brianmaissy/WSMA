class DemoController < ApplicationController

  
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
 

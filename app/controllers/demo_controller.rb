class DemoController < ApplicationController

  def advance_time
    TimeProvider.advance_mock_time(params[:hours].to_f.hours)
    respond_to do |format|
      format.js
    end
  end

  def mock_time
    TimeProvider.set_mock_mode
    TimeProvider.set_mock_time
    respond_to do |format|
      format.js
    end
  end

  def real_time
    TimeProvider.set_mock_mode false
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
 

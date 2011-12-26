class HousesController < ApplicationController

  before_filter :authenticate
  before_filter :authorize_admin

  # GET /houses
  # GET /houses.json
  def index
    @houses = House.all
    @house = House.new

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @houses }
    end
  end

  # GET /houses/1
  # GET /houses/1.json
  def show
    @house = House.find(session[:user_id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @house }
    end
  end

  # GET /houses/new
  # GET /houses/new.json
  def new
    @house = House.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @house }
    end
  end

  # GET /houses/1/edit
  def edit
    @house = House.find(params[:id])
  end

  # POST /houses
  # POST /houses.json
  def create
    @house = House.new(params[:house])

    respond_to do |format|
      if @house.save
        flash.now[:notice] = 'House created'
        format.html { redirect_to :houses }
        format.json { render :json => @house, :status => :created, :location => @house }
        format.js
      else
        flash.now[:notice] = ('<ul><li>' + (@house.errors.full_messages.join "</li><li>") + '</li></ul>').html_safe
        format.html { render :action => "index" }
        format.json { render :json => @house.errors, :status => :unprocessable_entity }
        format.js
      end
    end
  end

  # PUT /houses/1
  # PUT /houses/1.json
  def update
    @house = House.find(params[:id])

    respond_to do |format|
      if @house.update_attributes(params[:house])
        format.html { redirect_to :houses, :notice => 'House updated' }
        format.json { head :ok }
      else
        format.html { render :action => "index" }
        format.json { render :json => @house.errors.full_messages, :status => :unprocessable_entity }
      end
    end
  end
 
#PUT /houses
#GET /houses

  def managefines
    @user = User.find(session[:user_id])
    @house = House.find(@user.house_id)

    if @user.access_level == 2
      respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @house }
    end
  end
end


  # DELETE /houses/1
  # DELETE /houses/1.json
  def destroy
    @house = House.find(params[:id])
    @house.destroy

    respond_to do |format|
      flash.now[:notice] = 'House deleted'
      format.html { redirect_to :action => "index" }
      format.json { head :ok }
      format.js { render :js => 'flash_green("' + flash[:notice] + '")' }
    end
  end
end

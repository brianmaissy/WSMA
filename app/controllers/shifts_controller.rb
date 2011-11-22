class ShiftsController < ApplicationController

  before_filter :authenticate, :except => [:login, :logout]
  before_filter :authorize_wsm, :except => [:login, :logout, :show]

  # GET /shifts
  # GET /shifts.json
  def index
    @shifts = Shift.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @shifts }
    end
  end

  # GET /shifts/1
  # GET /shifts/1.json
  def show
    @shift = Shift.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render :json => @shift }
    end
  end

  # GET /shifts/new
  # GET /shifts/new.json
  def new
    @shift = Shift.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @shift }
    end
  end

  # GET /shifts/1/edit
  def edit
    @shift = Shift.find(params[:id])
  end

  # POST /shifts
  # POST /shifts.json
  def create
    @shift = Shift.new(params[:shift])

    respond_to do |format|
      if @shift.save
        format.html { redirect_to :back, :notice => 'Shift was successfully created.' }
        format.json { render :json => @shift, :status => :created, :location => @shift }
      else
        format.html { render :action => "new" }
        format.json { render :json => @shift.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /shifts/1
  # PUT /shifts/1.json
  def update
    @shift = Shift.find(params[:id])

    respond_to do |format|
      if @shift.update_attributes(params[:shift])
        format.html { redirect_to '/createChore', :notice => 'Shift was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render :action => "edit" }
        format.json { render :json => @shift.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /shifts/1
  # DELETE /shifts/1.json
  def destroy
    @shift = Shift.find(params[:id])
    @shift.destroy

    respond_to do |format|
      format.html { redirect_to :back }
      format.json { head :ok }
    end
  end

  def manageShiftstable
    @user = User.find(session[:user_id])
    @chores = Chore.find_all_by_house_id(@user.house_id)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @shifts }

    end

  end

  def manageshifts
    @user = User.find(session[:user_id])
    @chores = Chore.find_all_by_house_id(@user.house_id)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :json => @shifts }
    end
  end
end
